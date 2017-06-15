//
//  FaceHandleImage.h
//  faceSDK
//
//  Created by Alex on 17/4/12.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface FaceHandleImage : NSObject

/**
 * 实时处理照片流
 */
+(UIImage *)sampleBufferToImage:(CMSampleBufferRef)sampleBuffer;

/**
 *修正照片
 */
+(UIImage *)fixOrientation:(UIImage *)aImage;

/**
 *裁剪照片
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

@end
