//
//  FaceTurnVertical.m
//  faceSDK
//
//  Created by Alex on 17/4/12.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "FaceTurnVertical.h"

@implementation FaceTurnVertical

+(CGRect)verticalFlipFromRect:(CGRect)originalRect inSize:(CGSize)originalSize toSize:(CGSize)finalSize{
    CGRect finalRect = originalRect;
    finalRect.origin.y = originalSize.height - finalRect.origin.y - finalRect.size.height;
    CGFloat hRate = finalSize.width / originalSize.width;
    CGFloat vRate = finalSize.height / originalSize.height;
    finalRect.origin.x *= hRate;
    finalRect.origin.y *= vRate;
    finalRect.size.width *= hRate;
    finalRect.size.height *= vRate;
    return finalRect;

}

+(CGPoint)verticalFlipFromPoint:(CGPoint)originalPoint inSize:(CGSize)originalSize toSize:(CGSize)finalSize{
    CGPoint finalPoint = originalPoint;
    finalPoint.y = originalSize.height - finalPoint.y;
    CGFloat hRate = finalSize.width / originalSize.width;
    CGFloat vRate = finalSize.height / originalSize.height;
    finalPoint.x *= hRate;
    finalPoint.y *= vRate;
    return finalPoint;

}
@end
