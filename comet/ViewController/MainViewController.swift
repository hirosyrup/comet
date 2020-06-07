//
//  ViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/17.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    private var repositoryList = [Repository]()
    private let preferencesWindowController = PreferencesWindowController.create()
    
    class func create(repositoryList: [Repository]) -> MainViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MainViewController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! MainViewController
        vc.repositoryList = repositoryList
        return vc
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let tabVc = segue.destinationController as? RepositoryTabViewController {
            tabVc.repositoryList = repositoryList
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pushPreferences(_ sender: Any) {
        if let window = preferencesWindowController.window {
            NSApp.runModal(for: window)
        }
    }
    
    @IBAction func pushQuit(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}

