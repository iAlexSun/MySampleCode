//
//  UIimageExtension.swift
//  CMCoreMLDetect
//
//  Created by Alex on 2017/6/10.
//  Copyright © 2017年 Alex. All rights reserved.
//

import UIKit

extension UIImage{
    
    func convertToPixelBuffer(image:UIImage,imageFrame:CGFloat) -> CVPixelBuffer? {
        var pixelBuffer : CVPixelBuffer?
        let imageDimension : CGFloat = imageFrame
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let imageSize = CGSize(width:imageDimension, height:imageDimension)
        let imageRect = CGRect(origin: CGPoint(x:0, y:0), size: imageSize)
        
        let options = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                       kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 1.0)
        image.draw(in:imageRect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(newImage.size.width),
                                         Int(newImage.size.height),
                                         kCVPixelFormatType_32ARGB,
                                         options,
                                         &pixelBuffer)
        guard (status == kCVReturnSuccess),
            let uwPixelBuffer = pixelBuffer else {
                return nil
        }
        
        CVPixelBufferLockBaseAddress(uwPixelBuffer,
                                     CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(uwPixelBuffer)
        let context = CGContext(data: pixelData,
                                width: Int(newImage.size.width),
                                height: Int(newImage.size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(uwPixelBuffer),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        guard let uwContext = context else {
            return nil
        }
        
        uwContext.translateBy(x: 0, y: newImage.size.height)
        uwContext.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(uwContext)
        newImage.draw(in: CGRect(x: 0,
                                 y: 0,
                                 width: newImage.size.width,
                                 height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(uwPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
}
