//
//  PreferencesBitbucketUserInputViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/15.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class PreferencesBitbucketUserInputViewController: NSViewController {

    class func create() -> PreferencesBitbucketUserInputViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PreferencesBitbucketUserInputViewController")
        return storyboard.instantiateController(withIdentifier: identifier) as! PreferencesBitbucketUserInputViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func pushCancelButton(_ sender: Any) {
        dismiss(self)
    }
    
    @IBAction func pushOkButton(_ sender: Any) {
        dismiss(self)
    }
}
