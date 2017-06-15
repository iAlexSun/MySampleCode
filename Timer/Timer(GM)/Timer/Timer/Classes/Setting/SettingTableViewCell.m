//
//  SettingTableViewCell.m
//  TimerDemo
//
//  Created by Alex on 2017/6/2.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "SettingTableViewCell.h"
#define CellBoder 8
#define FontSize 18
@interface SettingTableViewCell()
/**      title       */
@property(nonatomic,weak)UILabel  *titleLabel;

@end

@implementation SettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    //自定义cell中的元素要在这里进行初始化
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化控件
        [self initLayout];
        
    }
    return self;
}
//初始化控件
-(void)initLayout{
    
    UILabel  *titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIImageView  *duihaoimageView = [[UIImageView alloc]init];
    [self.contentView addSubview:duihaoimageView];
    self.duihaoimageView = duihaoimageView;
    self.duihaoimageView.hidden = YES;
    
    CGFloat imageViewWH = 30;
    CGFloat imageViewX = [[UIScreen mainScreen] bounds].size.width-CellBoder-imageViewWH;
    CGFloat imageViewY = CellBoder;
    self.duihaoimageView.image = [UIImage imageNamed:@"duihao"];
    self.duihaoimageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWH, imageViewWH);
}

-(void)setTitle:(NSString *)title {

    CGFloat titleLabelX = CellBoder;
    CGFloat titleLabelY = CellBoder;
    CGFloat titleLabelW = 200;
    CGFloat titleLabelH = 30;
    
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:FontSize]];
    self.backgroundColor = [UIColor blackColor];
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
}


-(void)setItemisSelected{
    
    self.duihaoimageView.hidden = !self.duihaoimageView.hidden;
  
}
@end
