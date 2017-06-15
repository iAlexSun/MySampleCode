//
//  AddSettingItemTableViewController.h
//  TimerDemo
//
//  Created by Alex on 2017/6/1.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddSettingItemViewDelegate <NSObject>

-(void)addSettingItemFinish;

@end

@interface AddSettingItemTableViewController : UITableViewController

@property(nonatomic,strong)id<AddSettingItemViewDelegate> delegate;

@property(nonatomic,strong)NSMutableArray *settingItemArr;

@end
