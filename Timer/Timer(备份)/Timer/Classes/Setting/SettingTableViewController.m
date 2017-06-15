//
//  SettingTableViewController.m
//  TimerDemo
//
//  Created by Alex on 2017/5/31.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "SettingTableViewController.h"
#import "WorkFlowTableViewController.h"
#import "AddSettingItemTableViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SettingTableViewCell.h"

@interface SettingTableViewController ()<AddSettingItemViewDelegate>
@property(nonatomic,strong)NSMutableArray *workFlowArrary;
@property(nonatomic,strong)NSMutableArray *workFlowDetailArrary;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];

    [self getData];
    
    
   
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
    
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(add) image:@"add_workflow"];
    
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableFooterView = footerView;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

//添加工作流程
-(void)add{
    
    AddSettingItemTableViewController *addSettingItemTableViewController = [[AddSettingItemTableViewController alloc]init];
    addSettingItemTableViewController.delegate = self;
    addSettingItemTableViewController.settingItemArr = self.workFlowArrary;

    [self.navigationController pushViewController:addSettingItemTableViewController animated:YES];
    
}

//添加完成
-(void)addSettingItemFinish{
    if ([self.workFlowArrary count]>0) {
        [self.workFlowArrary removeAllObjects];
        [self.workFlowDetailArrary removeAllObjects];
    }
    
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    
    for (int i = 0; i<[array count]; i++) {
        NSMutableDictionary *dic = [array objectAtIndex:i];
        
        NSString *title = dic[@"title"];
        NSArray *detailArr = dic[@"array"];
        [self.workFlowArrary addObject:title];
//        [self.workFlowDetailArrary addObject:detailArr];
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.workFlowArrary count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSUserDefaults *selected = [NSUserDefaults standardUserDefaults];
    NSString  *selectedItem = [selected objectForKey:@"selected"];
    
    static NSString *ID = @"settingCell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell){
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if (indexPath.row == [selectedItem integerValue]) {
        cell.duihaoimageView.hidden = NO;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTitle: [self.workFlowArrary objectAtIndex:indexPath.row]];

    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *selectdIndex = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSUserDefaults *selected = [NSUserDefaults standardUserDefaults];
    [selected setObject:selectdIndex forKey:@"selected"];
    [selected synchronize];
    
    WorkFlowTableViewController *workFlowTableViewController = [[WorkFlowTableViewController alloc]init];
    workFlowTableViewController.workFlowDetailArrIndex = indexPath.row;

    NSArray *array = [tableView visibleCells];
    for (int i =0; i<[array count]; i++) {
        SettingTableViewCell *cell = array[i];
        cell.duihaoimageView.hidden = YES;
    }
    
    
    SettingTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setItemisSelected];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:workFlowTableViewController animated:YES];
    });
 
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.workFlowArrary removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fileName];
            [array removeObjectAtIndex:indexPath.row];
            [array writeToFile:fileName atomically:YES];
        });
        
    }
}

-(NSMutableArray *)workFlowDetailArrary{
    if (_workFlowDetailArrary) {
        _workFlowDetailArrary = [[NSMutableArray alloc]init];
    }
    return _workFlowDetailArrary;
}

-(NSMutableArray *)workFlowArrary{
    if (!_workFlowArrary) {
        _workFlowArrary = [[NSMutableArray alloc]init];
    }
    return _workFlowArrary;
}

-(void)getData{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    
    for (int i = 0; i<[array count]; i++) {
        NSMutableDictionary *dic = [array objectAtIndex:i];
        
        NSString *title = dic[@"title"];
        NSArray *detailArr = dic[@"array"];
        [self.workFlowArrary addObject:title];
        [self.workFlowDetailArrary addObject:detailArr];
    }
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

@end
