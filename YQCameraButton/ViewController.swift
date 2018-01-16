//
//  ViewController.swift
//  YQCameraButton
//
//  Created by Wang on 2018/1/16.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: YQCameraButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button.type = .video
    }
    @IBAction func tapAction(_ sender: Any) {
        if button.type == .photo {
            button.type = .video
        } else if button.type == .video {
            button.type = .photo
        }
    }
    
    @IBAction func touchAction(_ sender: YQCameraButton) {
        sender.yq.isSelected = !sender.yq.isSelected
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

