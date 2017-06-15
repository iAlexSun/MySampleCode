//
//  ViewController.m
//  TimerDemo
//
//  Created by Alex on 17/4/1.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "TimerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MZTimerLabel.h"
#import "TimerTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface TimerViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property(nonatomic,strong)MPVolumeView *volumeView;

@property(nonatomic,strong)MZTimerLabel *stopwatch;

@property (weak, nonatomic)IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSString *nowTime; //现在时间

@property(nonatomic,weak)IBOutlet UILabel *timerLabel;  //计时器

@property(nonatomic,assign)float nowVolume; //现在音量

@property(nonatomic,assign)float lastVolume;  //上一次音量

@property(nonatomic,strong)MPMusicPlayerController *mpc;

@property(nonatomic,assign)CGFloat nowTimeY;

@property(nonatomic,strong)UISlider *volumeViewSlider ;

@property(nonatomic,assign)int index ; //序号

@property(nonatomic,strong)NSMutableArray *timeArray;

@property(nonatomic,strong)NSMutableArray *workFlowTimeArr;

@property(nonatomic,strong)NSMutableArray *timeDifferenceArr;

@property(nonatomic,assign)BOOL isPasue;

@property(nonatomic,assign)NSString *lastTime;


@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    [self initTimer];
 
    self.isPasue = YES;
    
//    [self dataWriteToFile];
    
    self.lastTime = @"00:00:00";

}

-(void)initView{

    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    //设置选择后的文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:239/255.0 green:179/255.0 blue:54/255.0 alpha:1.0];
    //正常状态下文字颜色
    [self.navigationController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //选中后的文字颜色
    [self.navigationController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-65, 0, 0, 0)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.title = @"秒表";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.tableView.backgroundColor = [UIColor blackColor];
    
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableFooterView = footerView;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"复位" style:UIBarButtonItemStyleDone target:self action:@selector(OnRightButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"开始" style:UIBarButtonItemStyleDone target:self action:@selector(OnLeftButton)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)initTimer{
    
    self.index = 0;
    self.nowTimeY = 300;
    self.mpc = [[MPMusicPlayerController alloc]init];
    self.stopwatch = [[MZTimerLabel alloc] initWithLabel:self.timerLabel];
    [self initVolumeView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
}

-(void)OnRightButton{
    [self.timeArray removeAllObjects];
    [self.workFlowTimeArr removeAllObjects];
    [self.timeDifferenceArr removeAllObjects];
    self.index = 0;
       self.lastTime = @"00:00:00";
    [self.tableView reloadData];
    [self.stopwatch reset];
    [self.stopwatch pause];

}

-(void)sendEmailAction{
    
    if(![MFMailComposeViewController canSendMail]) return;
    
    MFMailComposeViewController *MFMailVC = [[MFMailComposeViewController alloc] init];
    
    //设置邮件主题
    [MFMailVC setSubject:@"汽车生产线"];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    NSUserDefaults *selected = [NSUserDefaults standardUserDefaults];
    NSString  *selectedItem = [selected objectForKey:@"selected"];

    NSMutableDictionary *dic = [array objectAtIndex:[selectedItem integerValue]];
    NSString *workFlowData = dic[@"title"];

    
    for (int i =0; i<[self.timeDifferenceArr count]; i++) {
        
        workFlowData = [workFlowData stringByAppendingFormat:@" %@ %@",[self.workFlowTimeArr objectAtIndex:i],[self.timeDifferenceArr objectAtIndex:i]];
    }
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *file = [workFlowData dataUsingEncoding:enc];
    
    [MFMailVC addAttachmentData:file mimeType:@"" fileName: @"汽车生产线.csv"];
    
    //设置收件人列表
    [MFMailVC setToRecipients:@[@""]];
    //设置代理
    MFMailVC.mailComposeDelegate = self;
    
    //显示控制器
    [self presentViewController:MFMailVC animated:YES completion:nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)OnLeftButton{
    
    self.isPasue = !self.isPasue;
    
    if (self.isPasue == YES) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"开始" style:UIBarButtonItemStyleDone target:self action:@selector(OnLeftButton)];
        self.navigationItem.leftBarButtonItem = leftItem;
        [self.stopwatch pause];
    }else{
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"暂停" style:UIBarButtonItemStyleDone target:self action:@selector(OnLeftButton)];
        self.navigationItem.leftBarButtonItem = leftItem;
        [self.stopwatch start];
    }
}



- (void)volumeChanged:(NSNotification *)notification
{
    
    
//    NSLog(@"%@",notification.userInfo);
    
//    self.mpc.volume = [self deviceVolume];
    
    float volume = [[[notification userInfo]objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    
    if ([self.stopwatch.timeLabel.text  isEqual:@"00:00:00"]) {
        
        [self getData];
        
        [self.stopwatch start];
        
        self.isPasue = NO;
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"暂停" style:UIBarButtonItemStyleDone target:self action:@selector(OnLeftButton)];
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }else{
   
        if ([self.workFlowTimeArr count] > self.index){
    
            self.nowTime = self.stopwatch.timeLabel.text;
            
            NSString *timeString = self.nowTime;

            NSString *timeDefferentStr = [self pleaseInsertStarTime:self.lastTime andInsertEndTime:self.nowTime];

            [self.timeDifferenceArr addObject:timeDefferentStr];
            [self.timeArray addObject:timeString];
            
            self.lastTime = self.nowTime;
            self.index++;
            
            if ([self.workFlowTimeArr count] == self.index) {
                 [self.stopwatch pause];
            }
        }
    }
    
    [self.tableView reloadData];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

/**
 *  Description 设置系统音量部分
 *
 */

- (CGFloat)deviceVolume{
    return [[AVAudioSession sharedInstance] outputVolume];
}

- (void)initVolumeView {
    
    //不显示“铃声”，显示“音量”
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    
    // 修改系统音量
    [self.volumeView setHidden:NO];
    self.volumeViewSlider = nil;
    [self.view addSubview:self.volumeView];

    //    self.volumeView.showsVolumeSlider = NO;
    
//    for (UIView *view in [self.volumeView subviews]){
//        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
//            self.volumeViewSlider = (UISlider*)view;
//            break;
//        }
//    }
//    
//    // retrieve system volume
////    float systemVolume = self.volumeViewSlider.value;
//    
//    // change system volume, the value is between 0.0f and 1.0f
//    [self.volumeViewSlider setValue:[self deviceVolume] animated:NO];
}

- (void)setVolume:(float)value
{
    
    [self.volumeViewSlider setValue:value animated:NO];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.timeArray count];
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *ID = @"timeCell";
     TimerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
     if (!cell) {
         cell = [[TimerTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
     }
     if ([self.timeArray count]>0) {
         [cell setWorkFlowTime:[self.timeArray objectAtIndex:indexPath.row]
                 workFlowTitle:[self.workFlowTimeArr objectAtIndex:indexPath.row]timeDifference:[self.timeDifferenceArr objectAtIndex:indexPath.row]];
     }
     return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        [self sendEmailAction]; // 调用发送邮件的代码
    }
}


-(void)getData{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    
    NSUserDefaults *selected = [NSUserDefaults standardUserDefaults];
    NSString  *selectedItem = [selected objectForKey:@"selected"];

    NSMutableDictionary *dic = [array objectAtIndex:[selectedItem integerValue]];
    
    self.workFlowTimeArr = dic[@"array"];
  
    
}


-(NSMutableArray *)workFlowTimeArr{
    if (!_workFlowTimeArr) {
        _workFlowTimeArr = [[NSMutableArray alloc]init];
    }
    return _workFlowTimeArr;
}

-(NSMutableArray *)timeArray{
    if (!_timeArray) {
        _timeArray = [[NSMutableArray alloc]init];
    }
    return _timeArray;
}

-(NSMutableArray *)timeDifferenceArr{

    if (!_timeDifferenceArr) {
        _timeDifferenceArr = [[NSMutableArray alloc]init];
    }
    return _timeDifferenceArr;
}

-(MPVolumeView *)volumeView{
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc]init];
    }
    return _volumeView;
}

-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


- (NSString *)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"mm:ss:SS"];//根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    
    NSString *time = nil;
    
    int seconds = (int)timeInterval % 60;
    int minutes = (int)(timeInterval / 60) % 60;
    int hours = (int)timeInterval / 3600;
    
    if (minutes>0) {
        if (hours>0) {
            NSString *timeResult = [NSString stringWithFormat:@"%d小时%d分%d秒",hours,minutes,seconds];
            return timeResult;
        }else{
            NSString *timeResult = [NSString stringWithFormat:@"%d分%d秒",minutes,seconds];
            return timeResult;
        }
    }else{
        NSString *timeResult = [NSString stringWithFormat:@"%d秒",seconds];
        return timeResult;
    }
    return time;
}
@end
