//
//  TimerTableViewCell.m
//  TimerDemo
//
//  Created by Alex on 2017/6/4.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "TimerTableViewCell.h"
#define workFlowBoder 8
#define FontSize 18
@interface TimerTableViewCell()

/**      workFlowLabel       */
@property(nonatomic,weak)UILabel  *workFlowLabel;

/**      timeLabel       */
@property(nonatomic,weak)UILabel  *timeLabel;

/**      时间差       */
@property(nonatomic,weak)UILabel  *timeDifferenceLabel;

@end

@implementation TimerTableViewCell

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
    
    UILabel  *workFlowLabel = [[UILabel alloc]init];
    [self.contentView addSubview:workFlowLabel];
    self.workFlowLabel = workFlowLabel;
    
    UILabel  *timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
   
    UILabel  *timeDifferenceLabel = [[UILabel alloc]init];
    [self.contentView addSubview:timeDifferenceLabel];
    self.timeDifferenceLabel = timeDifferenceLabel;
    
    self.backgroundColor = [UIColor blackColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)setWorkFlowTime:(NSString *)workFlowTime workFlowTitle:(NSString *)workFlowTitle timeDifference:(NSString *)timeDifference{
    
//    NSString *timeText = [workFlowTime substringFromIndex:(workFlowTime.length-8)]; //时间
//    NSString *workFlowText = [workFlowTime substringToIndex:(workFlowTime.length-8)]; //工作流名称
    
    CGFloat workFlowLabelXY = workFlowBoder;
    CGFloat workFlowLabelW = 140;
    CGFloat workFlowLabelH = 30;
    self.workFlowLabel.frame = CGRectMake(workFlowLabelXY, workFlowLabelXY, workFlowLabelW, workFlowLabelH);
    self.workFlowLabel.text = workFlowTitle;
    self.workFlowLabel.textColor = [UIColor whiteColor];
    [self.workFlowLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:FontSize]];
    
    
    CGFloat timeLabelW = 100;
    CGFloat timeLabelH = workFlowLabelH;
    CGFloat timeLabelX = CGRectGetMaxX(self.workFlowLabel.frame);
    CGFloat timeLabelY = workFlowLabelXY;
    
    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.text = workFlowTime;
    self.timeLabel.textColor = [UIColor whiteColor];
    [self.timeLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:FontSize]];
       
    CGFloat timeDifferenceLabelW = 130;
    CGFloat timeDifferenceLabelH = workFlowLabelH;
    CGFloat timeDifferenceLabelX = [UIScreen mainScreen].bounds.size.width-timeDifferenceLabelW-workFlowBoder;
    CGFloat timeDifferenceLabelY = workFlowLabelXY;
    self.timeDifferenceLabel.frame = CGRectMake(timeDifferenceLabelX, timeDifferenceLabelY, timeDifferenceLabelW, timeDifferenceLabelH);
    self.timeDifferenceLabel.textAlignment = NSTextAlignmentRight;
    self.timeDifferenceLabel.text = timeDifference;
    self.timeDifferenceLabel.textColor = [UIColor whiteColor];
    [self.timeDifferenceLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:FontSize]];
  

}
@end
