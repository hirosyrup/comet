//
//  PullRequestViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class PullRequestViewController: NSViewController {
    @IBOutlet weak var listView: NSCollectionView!
    
    class func create() -> PullRequestViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PullRequestViewController")
        return storyboard.instantiateController(withIdentifier: identifier) as! PullRequestViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func backgroundColor() -> NSColor? {
        return listView.backgroundColors.first
    }
}
