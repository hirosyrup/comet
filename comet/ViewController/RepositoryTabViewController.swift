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
    
    var repositoryList = [Repository]()
    
    private var tabItemWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vcList = createChildViewControllers()
        
        if vcList.isEmpty {
            selectBarView.isHidden = true
        } else {
            tabItemWidth = tabItemContainerView.bounds.width / CGFloat(vcList.count)
            selectBarWidthConstraint.constant = tabItemWidth
            
            let needLabel = vcList.count > 1
            if !needLabel {
                selectBarView.isHidden = true
                tabItemContainerHeightConstraint.constant = 0.0
            }
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
    
    private func addViewController(vc: PullRequestViewController, needLabel: Bool, index: Int) {
        let selected = tabContentView.subviews.isEmpty
        
        let tabViewItem = NSTabViewItem()
        tabViewItem.viewController = vc
        tabContentView.addTabViewItem(tabViewItem)
        
        if needLabel {
            let tabLabel = NSTextField(labelWithString: vc.title ?? "tab")
            tabLabel.frame = NSRect(x: CGFloat(index) * tabItemWidth, y: 0, width: tabItemWidth, height: tabItemContainerView.bounds.height)
            tabLabel.alignment = NSTextAlignment.center
            tabLabel.tag = index
            tabLabel.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(clickTab(gesture:))))
            tabItemContainerView.addSubview(tabLabel)
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
