//
//  ViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/17.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

protocol MainViewControllerDelegate: class {
    func didUpdateCount(vc: MainViewController, unreadCommentCount: Int, inReviewCount: Int)
}

class MainViewController: NSViewController, PreferencesWindowControllerDelegate, RepositoryNotification {
    @IBOutlet weak var updatingIndicator: NSProgressIndicator!
    
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
        updateIndicator()
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
    
    private func notifyUpdated() {
        let dataList = repositoryList.flatMap { $0.pullRequestDataList() }
        NotifyNewUnreadComment(dataList: dataList).notify()
        NotifyNewCommit(dataList: dataList).notify()
    }
    
    private func isUpdating() -> Bool {
        return !repositoryList.filter { $0.isUpdating }.isEmpty
    }
    
    private func updateIndicator() {
        guard let indicator = updatingIndicator else { return }
        if isUpdating() {
            indicator.startAnimation(nil)
        } else {
            indicator.stopAnimation(nil)
        }
    }
    
    func willClose(vc: PreferencesWindowController) {
        updateRepositoryList()
    }
    
    func willUpdateRepository(repository: RepositoryObservable) {
        updateIndicator()
    }
    
    func didUpdateRepository(repository: RepositoryObservable) {
        notifyUpdated()
        if let _delegate = delegate {
            let dataList = repositoryList.flatMap { $0.pullRequestDataList() }
            let calcUnreadCommentCountList = dataList.map {CalcUnreadCommentCount(data: $0)}
            let unreadCommentCount = calcUnreadCommentCountList.map { $0.unreadCommentCount() }.reduce(0, +)
            let inReviewCount = SeparatePullRequestDataList(pullRequestDataList: dataList).inReviewList.count
            _delegate.didUpdateCount(vc: self, unreadCommentCount: unreadCommentCount, inReviewCount: inReviewCount)
        }
        updateIndicator()
    }
    
    func failedUpdateRepository(repository: RepositoryObservable, error: Error) {
        updateIndicator()
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

