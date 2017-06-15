//
//  SSWVideoFuncitons.swift
//  SSWVideoView
//
//  Created by Alex on 17/3/1.
//  Copyright © 2017年 Alex. All rights reserved.
//

import UIKit

class SSWVideoFuncitons: NSObject {

    //获得用户信息
    class func getUserInfo()->NSDictionary{
        //获得视频路径文件
        let MD5PlistPath = Bundle.main.path(forResource:"C415F3F13BBD50B1-info", ofType: "plist");
        let dict = NSDictionary.init(contentsOfFile: MD5PlistPath!)!;
        return dict;

    }
    
    //获取视频url
    class func getVideoUrl()->String{
        let videoUrl = SSWVideoFuncitons.getUserInfo().object(forKey: "Url");
        
        return videoUrl as! String;
    }
    
    //获取视频类型
    class func getVideoType()->String{
        let videoType = SSWVideoFuncitons.getUserInfo().object(forKey: "Type");
        
        return videoType as! String;
    }
    
    //获取是否循环
    class func getLoopMode()->Bool{
        let videoLoopMode =  SSWVideoFuncitons.getUserInfo().object(forKey: "Mode Loop");
        
        return (videoLoopMode != nil) ;
    }
    
}
