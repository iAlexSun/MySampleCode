//
//  AddSettingItemTableViewController.m
//  TimerDemo
//
//  Created by Alex on 2017/6/1.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "AddSettingItemTableViewController.h"
#define Border 8

@interface AddSettingItemTableViewController ()

@property(nonatomic,strong)UITextField *textField;

@end

@implementation AddSettingItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加项目";
    
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

-(void)OnRightButton{
    
    if (![self.textField.text isEqual:@""]) {
        
        [self isWorkFlowArrayEmpty];
   
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fileName];
        
        NSArray *workflowArr = [[NSArray alloc]init];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
        [dic setValue:self.textField.text forKey:@"title"];
        [dic setValue:workflowArr forKey:@"array"];
            
        [array addObject:dic];
        [array writeToFile:fileName atomically:YES];
        
        [self.delegate addSettingItemFinish];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
}

-(void)isWorkFlowArrayEmpty{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"workFlow.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fileName];
    
    if (array == nil) {
        NSMutableArray *workFlowArrays = [[NSMutableArray alloc]init];
        [workFlowArrays writeToFile:fileName atomically:YES];
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
    static NSString *ID = @"addSetting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textField.frame = CGRectMake(Border,Border,cell.frame.size.width-Border,cell.frame.size.height-Border);
        self.textField.textColor = [UIColor whiteColor];
        [cell addSubview:self.textField];
        cell.backgroundColor = [UIColor blackColor];
        [cell setFont:[UIFont fontWithName:@"Helvetica Neue" size:20]];
    }
    return cell;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if ([theTextField.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
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
