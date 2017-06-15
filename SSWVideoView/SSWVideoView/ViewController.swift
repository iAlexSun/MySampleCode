//
//  ViewController.swift
//  SSWVideoView
//
//  Created by Alex on 17/3/1.
//  Copyright © 2017年 Alex. All rights reserved.
//

import UIKit

class ViewController: SSWVideoViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpButton.layer.cornerRadius = 3
        self.signUpButton.layer.masksToBounds = true

        self.loginButton.layer.cornerRadius = 3
        self.loginButton.layer.masksToBounds = true
    }

}
