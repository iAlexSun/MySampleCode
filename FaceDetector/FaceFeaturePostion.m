//
//  FacePostion.m
//  faceSDK
//
//  Created by Alex on 17/4/17.
//  Copyright © 2017年 Alex. All rights reserved.
//

#import "FaceFeaturePostion.h"

@implementation FaceFeaturePostion


-(CGFloat)FaceFeaturePostionX{
    
    return self.faceFeature.bounds.origin.x;
}
-(CGFloat)FaceFeaturePostionY{
    
    return self.faceFeature.bounds.origin.y;
}
-(CGFloat)FaceFeaturePostionWidth{
    
    return self.faceFeature.bounds.size.width;
}
-(CGFloat)FaceFeaturePostionHeight{
    
    return self.faceFeature.bounds.size.height;
}

@end
