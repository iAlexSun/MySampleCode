//
//  SSWVideoViewController.swift
//  SSWVideoView
//
//  Created by Alex on 17/3/1.
//  Copyright © 2017年 Alex. All rights reserved.
//


import UIKit
import MediaPlayer

class SSWVideoViewController: UIViewController {

    var player = MPMoviePlayerController()    //初始化播放器
    
    var isLoop:Bool = true //判断是否循环播放
    

    override func viewWillAppear(_ animated: Bool) {
        
        self.getPlayerNotifications()
        
        self.player.play()
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: nil);
       
        self.player.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SSWVideoFuncitons.getUserInfo() != nil {
            self.isLoop = SSWVideoFuncitons.getLoopMode()
            self.preparePlayback()
        }
    }
    
    
    func getPlayerNotifications(){
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(self.moviePlayerStateChangeNotification(notification:)),
                                               name: .MPMoviePlayerPlaybackStateDidChange,
                                               object: nil);
    
    }
    

    func preparePlayback(){
        
            let url = URL.init(fileURLWithPath:(Bundle.main.path(forResource: SSWVideoFuncitons.getVideoUrl(), ofType: SSWVideoFuncitons.getVideoType())!));
            
            self.player = .init(contentURL:url)
            self.player.controlStyle = .none
            self.player.view.frame = self.view.frame
            self.view.addSubview(self.player.view)
            self.view.sendSubview(toBack: self.player.view)
            self.player.scalingMode = .aspectFill
        
    }
    
    
    //pragma - Notifications
    func moviePlayerStateChangeNotification(notification:NSNotification){
        
        let movieplayer = notification.object! as! MPMoviePlayerController
        
        switch movieplayer.playbackState {
            case .stopped,.paused,.interrupted:
                if self.isLoop {
                    self.player.controlStyle = .none
                    self.player.play()
                }
            
            default:
                break
        }
        
    }
    
    

}
