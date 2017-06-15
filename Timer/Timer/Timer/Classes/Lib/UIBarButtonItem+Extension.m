//
//  UIBarButtonItem+Extension.m
//  Alex--微博
//
//  Created by Alex on 15/12/6.
//  Copyright © 2015年 Alex. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)
//初始化左侧item
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image {
    
    //初始化更多按钮
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    //监听返回按钮按下
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //设置按钮背景
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //设置按钮的大小和背景一样大小
    btn.size=btn.currentBackgroundImage.size;
   
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
