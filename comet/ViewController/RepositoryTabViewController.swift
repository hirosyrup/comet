//
//  RepositoryTabViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class RepositoryTabViewController: NSViewController {
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
    private var tabLabelList = [NSTextField]()
    
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
    
    func initializeRepositoryList(list: [Repository]) {
        repositoryList = list
    }
    
    func updateRepositoryList(list: [Repository]) {
        repositoryList = list
        updateChildViewControllers()
    }
    
    private func updateChildViewControllers() {
        removeAllChildren()
        
        let vcList = createChildViewControllers()
        
        if vcList.isEmpty {
            selectBarView.isHidden = true
        } else {
            tabItemWidth = tabItemContainerView.bounds.width / CGFloat(vcList.count)
            selectBarWidthConstraint.constant = tabItemWidth
            
            let needLabel = vcList.count > 1
            selectBarView.isHidden = !needLabel
            tabItemContainerHeightConstraint.constant = needLabel ? initialTabItemContainerHeight : 0.0
            for (index, vc) in vcList.enumerated() {
                addViewController(vc: vc, needLabel: needLabel, index: index)
            }
        }
    }
    
    private func createChildViewControllers() -> [PullRequestViewController] {
        return repositoryList.map { (repository) -> PullRequestViewController in
            let vc = PullRequestViewController.create(repositoryObservable: repository)
            vc.title = repository.repositorySlug
            return vc
        }
    }
    
    private func removeAllChildren() {
        let tabViewItems = tabContentView.tabViewItems
        tabViewItems.forEach { tabContentView.removeTabViewItem($0) }
        tabLabelList.forEach { $0.removeFromSuperview() }
        tabLabelList.removeAll()
    }
    
    private func addViewController(vc: PullRequestViewController, needLabel: Bool, index: Int) {
        let selected = tabContentView.subviews.isEmpty
        
        let tabViewItem = NSTabViewItem()
        tabViewItem.viewController = vc
        tabContentView.addTabViewItem(tabViewItem)
        
        if needLabel {
            let tabLabel = NSTextField(labelWithString: vc.title ?? "tab")
            tabLabel.frame = NSRect(x: CGFloat(index) * tabItemWidth, y: 0, width: tabItemWidth, height: initialTabItemContainerHeight)
            tabLabel.alignment = NSTextAlignment.center
            tabLabel.tag = index
            tabLabel.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(clickTab(gesture:))))
            tabItemContainerView.addSubview(tabLabel)
            tabLabelList.append(tabLabel)
            if selected {
                selectBarLeadingConstraint.constant = tabItemContainerView.frame.minX
            }
        }
    }
    
    @objc func clickTab(gesture: NSClickGestureRecognizer) {
        guard let index = gesture.view?.tag else {
            return
        }
        
        tabContentView.selectTabViewItem(at: index)
        
        NSAnimationContext.runAnimationGroup({context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            
            self.selectBarLeadingConstraint.constant = CGFloat(index) * self.selectBarWidthConstraint.constant
            self.selectBarView.layoutSubtreeIfNeeded()
        }, completionHandler:nil)
    }
}
