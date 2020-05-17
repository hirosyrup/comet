//
//  ViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/17.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    class func create() -> MainViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MainViewController")
        return storyboard.instantiateController(withIdentifier: identifier) as! MainViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

