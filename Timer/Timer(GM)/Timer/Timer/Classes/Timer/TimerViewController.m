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


@property(nonatomic,strong)MZTimerLabel *stopwatch;

@property (weak, nonatomic)IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSString *nowTime; //现在时间

@property(nonatomic,weak)IBOutlet UILabel *timerLabel;  //计时器

@property(nonatomic,strong)MPMusicPlayerController *mpc;

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
    
    self.lastTime = @"00:00:00";
    
    [self setVolumeHidden:YES];

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
    self.mpc = [[MPMusicPlayerController alloc]init];
    self.stopwatch = [[MZTimerLabel alloc] initWithLabel:self.timerLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
}

-(void)OnRightButton{
    self.index = 0;
    self.lastTime = @"00:00:00";
    [self.timeArray removeAllObjects];
    [self.workFlowTimeArr removeAllObjects];
    [self.timeDifferenceArr removeAllObjects];
    [self.stopwatch reset];
    [self.stopwatch pause];
    [self.tableView reloadData];
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
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"计时结果" message:nil preferredStyle:UIAlertControllerStyleAlert];
                //发送邮件按钮
                
                UIAlertAction *EmailButton  = [UIAlertAction actionWithTitle:@"发送邮件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                        [self sendEmailAction]; // 调用发送邮件的代码
                    }else{
                        NSString *version = [UIDevice currentDevice].systemVersion;
                        
                        if(version.doubleValue<10.0){
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录邮箱后发送邮件" message:nil preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *CancleButton  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                            [alertController addAction:CancleButton];
                            [self presentViewController:alertController animated:YES completion:nil];
                            [[UIApplication sharedApplication] openURL:@"mailto://"];
                        }else{
                            
                            NSURL * url = [NSURL URLWithString:@"mailto://"];
                            [[UIApplication sharedApplication] openURL:url options:[NSDictionary dictionary] completionHandler:nil];
                        }
                        
                    }
                }];
                //取消按钮
                UIAlertAction *CancleButton  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                [alertController addAction:EmailButton];
                [alertController addAction:CancleButton];
                [self presentViewController:alertController animated:YES completion:nil];
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"计时结果" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //发送邮件按钮
    
    UIAlertAction *EmailButton  = [UIAlertAction actionWithTitle:@"发送邮件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
            [self sendEmailAction]; // 调用发送邮件的代码
        }else{
            NSString *version = [UIDevice currentDevice].systemVersion;
            
            if(version.doubleValue<10.0){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录邮箱后发送邮件" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *CancleButton  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                [alertController addAction:CancleButton];
                [self presentViewController:alertController animated:YES completion:nil];
                [[UIApplication sharedApplication] openURL:@"mailto://"];
            }else{
                NSURL * url = [NSURL URLWithString:@"mailto://"];
                [[UIApplication sharedApplication] openURL:url options:[NSDictionary dictionary] completionHandler:nil];
            }
        }
    }];
    //取消按钮
    UIAlertAction *CancleButton  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:EmailButton];
    [alertController addAction:CancleButton];
    [self presentViewController:alertController animated:YES completion:nil];
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
//计算时间差
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


//调用私有API更改音量HUD问题进入后台后无法隐藏问题
- (void)setVolumeHidden:(BOOL)hidden
{
    NSString *str1 = @"etSystemV";
    NSString *str2 = @"eHUDEnabled";
    NSString *selectorString = [NSString stringWithFormat:@"s%@olum%@:forAudioCategory:", str1, str2];
    SEL selector = NSSelectorFromString(selectorString);
    
    if ([[UIApplication sharedApplication] respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIApplication instanceMethodSignatureForSelector:selector]];
        invocation.selector = selector;
        invocation.target = [UIApplication sharedApplication];
        BOOL value = !hidden;
        [invocation setArgument:&value atIndex:2];
        __unsafe_unretained NSString *category = @"Ringtone";
        [invocation setArgument:&category atIndex:3];
        [invocation invoke];
    }
}
@end
