//
//  AddWorkflowTableViewController.h
//  TimerDemo
//
//  Created by Alex on 2017/5/31.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddWorkflowTableViewController;

@protocol AddWorkflowTableViewDelegate <NSObject>

-(void)addWorkFlowFinish;

@end

@interface AddWorkflowTableViewController : UITableViewController

@property(nonatomic,strong)id<AddWorkflowTableViewDelegate> delegate;

@property(nonatomic,strong)NSMutableArray *workFlowDetailArr;

@property(nonatomic,assign)NSInteger *workFlowDetailArrIndex;
@end

