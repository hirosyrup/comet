//
//  ViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/17.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, PreferencesWindowControllerDelegate {
    private var repositoryList = [Repository]()
    private let preferencesWindowController = PreferencesWindowController.create()
    
    class func create() -> MainViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MainViewController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! MainViewController
        vc.updateRepositoryList()
        return vc
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let tabVc = segue.destinationController as? RepositoryTabViewController {
            tabVc.repositoryList = repositoryList
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preferencesWindowController.delegate = self
    }
    
    private func updateRepositoryList() {
        repositoryList.forEach {
            $0.stopTimer()
            $0.removeAllObserver()
        }
        let repositoryPreferences = try! RepositoryPreference.all()
        repositoryList = repositoryPreferences.map {
            Repository(repositoryOwner: $0.owner, repositorySlug: $0.slug, userName: $0.user.name, password: $0.user.password)
        }
        repositoryList.forEach {
            $0.startTimer()
            $0.updatePullRequest()
        }
    }
    
    func willClose(vc: PreferencesWindowController) {
        updateRepositoryList()
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

