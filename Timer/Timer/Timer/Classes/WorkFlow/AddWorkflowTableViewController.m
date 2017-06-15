//
//  AddWorkflowTableViewController.m
//  TimerDemo
//
//  Created by Alex on 2017/5/31.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "AddWorkflowTableViewController.h"

#define Border 8

@interface AddWorkflowTableViewController ()

@property(nonatomic,strong)UITextField *textField;
@end

@implementation AddWorkflowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加工作流";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor blackColor];
  
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(OnRightButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableFooterView = footerView;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if ([theTextField.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

-(void)OnRightButton{
    if (![self.textField.text isEqual:@""]) {
        
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fileName];
            
            NSMutableDictionary *dic = [array objectAtIndex:self.workFlowDetailArrIndex];
            NSMutableArray *detailArr = dic[@"array"];

            [detailArr addObject:self.textField.text];
            [dic setObject:detailArr forKey:@"array"];
            
            [array removeObjectAtIndex:self.workFlowDetailArrIndex];
            [array insertObject:dic atIndex:self.workFlowDetailArrIndex];
            [array writeToFile:fileName atomically:YES];
        
            [self.delegate addWorkFlowFinish];
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
       
    }

}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"workflowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textField.frame = CGRectMake(Border,Border,cell.frame.size.width-Border,cell.frame.size.height-Border);
        self.textField.textColor = [UIColor whiteColor];
        [cell addSubview:self.textField];
        cell.backgroundColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    }
    return cell;
}


-(UITextField *)textField{
    if (!_textField) {
         _textField = [[UITextField alloc]init];
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
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
