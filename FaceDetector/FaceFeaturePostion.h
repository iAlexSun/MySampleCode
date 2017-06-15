//
//  FaceFeaturePostion.h
//  faceSDK
//
//  Created by Alex on 17/4/17.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FaceFeaturePostion : NSObject
/**
 * 获取人脸位置信息
 */
@property(nonatomic, strong,readwrite)CIFaceFeature *faceFeature;
/**
 * 获取人脸每一帧图片
 */
@property(nonatomic, strong,readwrite)UIImage *FaceImage;
/**
 * 获取人脸位置X坐标信息
 */
-(CGFloat)FaceFeaturePostionX;
/**
 * 获取人脸位置Y坐标信息
 */
-(CGFloat)FaceFeaturePostionY;
/**
 * 获取人脸位置宽度信息
 */
-(CGFloat)FaceFeaturePostionWidth;
/**
 * 获取人脸位置高度信息
 */
-(CGFloat)FaceFeaturePostionHeight;

@end
