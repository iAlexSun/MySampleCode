//
//  WorkFlowTableViewController.m
//  TimerDemo
//
//  Created by Alex on 2017/5/31.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "WorkFlowTableViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "AddWorkflowTableViewController.h"
#define FontSize 18
@interface WorkFlowTableViewController ()<AddWorkflowTableViewDelegate>
@end

@implementation WorkFlowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initView];

    [self getData];
}


-(void)initView{
    self.navigationItem.title = @"工作流";
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
    
    AddWorkflowTableViewController *addWorkflowTableViewController = [[AddWorkflowTableViewController alloc]init];
    addWorkflowTableViewController.delegate = self;
    addWorkflowTableViewController.workFlowDetailArr = self.workFlowDetailArr;
    addWorkflowTableViewController.workFlowDetailArrIndex = self.workFlowDetailArrIndex;
    [self.navigationController pushViewController:addWorkflowTableViewController animated:YES];

}

-(void)addWorkFlowFinish{

    if ([self.workFlowDetailArr count]>0) {
        [self.workFlowDetailArr removeAllObjects];
    }
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableDictionary *dic = [array objectAtIndex:self.workFlowDetailArrIndex];
    NSArray *detailArr = dic[@"array"];
    
    self.workFlowDetailArr = detailArr;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.workFlowDetailArr count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *ID = @"workflow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.workFlowDetailArr objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    [cell setFont:[UIFont fontWithName:@"Helvetica Neue" size:FontSize]];
    return cell;
}

//先要设Cell可编辑
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.workFlowDetailArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
   
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fileName];
            
            NSMutableDictionary *dic = [array objectAtIndex:self.workFlowDetailArrIndex];
            NSMutableArray *detailArr = dic[@"array"];
            
            [detailArr removeObjectAtIndex:indexPath.row];
            [dic setObject:detailArr forKey:@"array"];
            
            [array removeObjectAtIndex:self.workFlowDetailArrIndex];
            
            [array insertObject:dic atIndex:self.workFlowDetailArrIndex];
          
            [array writeToFile:fileName atomically:YES];
        });
    }
}

-(NSMutableArray *)workFlowDetailArr{
    if (!_workFlowDetailArr) {
        _workFlowDetailArr = [[NSMutableArray alloc]init];
    }
    return _workFlowDetailArr;
}

//获取数据
-(void)getData{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableDictionary *dic = [array objectAtIndex:self.workFlowDetailArrIndex];
    self.workFlowDetailArr = dic[@"array"];
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
