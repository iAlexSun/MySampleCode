//
//  SettingTableViewCell.h
//  TimerDemo
//
//  Created by Alex on 2017/6/2.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
/**      对号       */
@property(nonatomic,weak)UIImageView *duihaoimageView;

-(void)setTitle:(NSString *)title;

-(void)setItemisSelected;
@end
