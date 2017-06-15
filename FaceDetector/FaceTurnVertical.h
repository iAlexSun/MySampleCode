//
//  FaceTurnVertical.h
//  faceSDK
//
//  Created by Alex on 17/4/12.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FaceTurnVertical : NSObject
/**
 * 对CGRect类型识别结果的坐标系进行结果位置需要变换（垂直翻转）
 */
+(CGRect)verticalFlipFromRect:(CGRect)originalRect inSize:(CGSize)originalSize toSize:(CGSize)finalSize;

/**
 * 对CGPoint类型识别结果的坐标系进行结果位置需要变换（垂直翻转）
 */
+(CGPoint)verticalFlipFromPoint:(CGPoint)originalPoint inSize:(CGSize)originalSize toSize:(CGSize)finalSize;

@end
