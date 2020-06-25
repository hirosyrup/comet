//
//  ViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/17.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

protocol MainViewControllerDelegate: class {
    func didUpdateUnreadCommentCount(vc: MainViewController, count: Int)
}

class MainViewController: NSViewController, PreferencesWindowControllerDelegate, RepositoryNotification {
    private var repositoryList = [Repository]()
    private let preferencesWindowController = PreferencesWindowController.create()
    private var repositoryTabVc: RepositoryTabViewController? = nil
    private weak var delegate: MainViewControllerDelegate?
    
    class func create(delegate: MainViewControllerDelegate? = nil) -> MainViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MainViewController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! MainViewController
        vc.updateRepositoryList()
        vc.delegate = delegate
        return vc
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let tabVc = segue.destinationController as? RepositoryTabViewController {
            repositoryTabVc = tabVc
            tabVc.initializeRepositoryList(list: repositoryList)
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
            $0.addObserver(observer: self)
            $0.startTimer()
            $0.updatePullRequest()
        }
        
        if let tabVc = repositoryTabVc {
            tabVc.updateRepositoryList(list: repositoryList)
        }
    }
    
    private func notifyNewUnreadComment() {
        let dataList = repositoryList.flatMap { $0.pullRequestDataList() }
        NotifyNewUnreadComment(dataList: dataList).notify()
    }
    
    func willClose(vc: PreferencesWindowController) {
        updateRepositoryList()
    }
    
    func didUpdateRepository(repository: RepositoryObservable) {
        notifyNewUnreadComment()
        if let _delegate = delegate {
            let dataList = repositoryList.flatMap { $0.pullRequestDataList() }
            let calcUnreadCommentCountList = dataList.map {CalcUnreadCommentCount(data: $0)}
            let count = calcUnreadCommentCountList.map { $0.unreadCommentCount() }.reduce(0, +)
            _delegate.didUpdateUnreadCommentCount(vc: self, count: count)
        }
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

