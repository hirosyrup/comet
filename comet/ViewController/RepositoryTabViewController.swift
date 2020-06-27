//
//  RepositoryTabViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class RepositoryTabViewController: NSViewController, RepositoryTabItemViewDelegate, RepositoryNotification {
    @IBOutlet weak var tabItemContainerView: NSBox!
    @IBOutlet weak var tabContentView: NSTabView!
    @IBOutlet weak var selectBarView: NSBox!
    @IBOutlet weak var tabItemContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectBarLeadingConstraint: NSLayoutConstraint!
    
    private var initialized = false
    private var repositoryList = [Repository]()
    private var tabItemWidth: CGFloat = 0.0
    private var initialTabItemContainerHeight: CGFloat = 0.0
    private var tabItemList = [RepositoryTabItemView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialTabItemContainerHeight = tabItemContainerHeightConstraint.constant
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        if !initialized {
            updateChildViewControllers()
            initialized = true
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        for i in 0..<tabItemList.count { updateTabItem(index: i) }
        repositoryList.forEach { $0.addObserver(observer: self) }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        repositoryList.forEach { $0.removeObserver(observer: self) }
    }
    
    func initializeRepositoryList(list: [Repository]) {
        repositoryList = list
    }
    
    func updateRepositoryList(list: [Repository]) {
        repositoryList = list
        updateChildViewControllers()
    }
    
    private func updateChildViewControllers() {
        removeAllChildren()
        
        if repositoryList.isEmpty {
            selectBarView.isHidden = true
        } else {
            tabItemWidth = tabItemContainerView.bounds.width / CGFloat(repositoryList.count)
            selectBarWidthConstraint.constant = tabItemWidth
            
            let needLabel = repositoryList.count > 1
            selectBarView.isHidden = !needLabel
            tabItemContainerHeightConstraint.constant = needLabel ? initialTabItemContainerHeight : 0.0
            for (index, repository) in repositoryList.enumerated() {
                addViewController(repository: repository, needLabel: needLabel, index: index)
            }
        }
    }
    
    private func removeAllChildren() {
        let tabViewItems = tabContentView.tabViewItems
        tabViewItems.forEach { tabContentView.removeTabViewItem($0) }
        tabItemList.forEach { $0.removeFromSuperview() }
        tabItemList.removeAll()
    }
    
    private func addViewController(repository: Repository, needLabel: Bool, index: Int) {
        let vc = PullRequestViewController.create(repositoryObservable: repository)
        let title = repository.repositorySlug
        vc.title = title
        
        let selected = tabContentView.subviews.isEmpty
        
        let tabViewItem = NSTabViewItem()
        tabViewItem.viewController = vc
        tabContentView.addTabViewItem(tabViewItem)
        
        if needLabel {
            let tabItem = RepositoryTabItemView.createFromNib(owner: tabItemContainerView, title: title, index: index)
            tabItem.frame = NSRect(x: CGFloat(index) * tabItemWidth, y: 0, width: tabItemWidth, height: initialTabItemContainerHeight)
            tabItem.delegate = self
            tabItemContainerView.addSubview(tabItem)
            tabItemList.append(tabItem)
            if selected {
                selectBarLeadingConstraint.constant = tabItemContainerView.frame.minX
            }
        }
    }
    
    private func updateTabItem(index: Int) {
        if index < tabItemList.count {
            let tabItem = tabItemList[index]
            let repository = repositoryList[index]
            let tabItemPresenter = RepositoryTabItemViewPresenter(dataList: repository.pullRequestDataList())
            tabItem.updateView(presenter: tabItemPresenter)
        }
    }
    
    func didClickTab(view: RepositoryTabItemView) {
        let index = view.index
        tabContentView.selectTabViewItem(at: index)
        
        NSAnimationContext.runAnimationGroup({context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            
            self.selectBarLeadingConstraint.constant = CGFloat(index) * self.selectBarWidthConstraint.constant
            self.selectBarView.layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    }
    
    func willUpdateRepository(repository: RepositoryObservable) {
    }
    
    func didUpdateRepository(repository: RepositoryObservable) {
        if let index = repositoryList.firstIndex(where: { $0 === repository as AnyObject }) {
            updateTabItem(index: index)
        }
    }
    
    func failedUpdateRepository(repository: RepositoryObservable, error: Error) {
    }
}
