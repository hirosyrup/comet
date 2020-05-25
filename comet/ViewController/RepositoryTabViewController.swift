//
//  RepositoryTabViewController.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class RepositoryTabViewController: NSViewController, NSSplitViewDelegate {
    @IBOutlet weak var tabItemContainerView: NSSplitView!
    @IBOutlet weak var tabContentView: NSTabView!
    @IBOutlet weak var tabItemContainerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabItemContainerView.delegate = self
        
        let vc1 = PullRequestViewController.create()
        vc1.title = "test1"
        let vc2 = PullRequestViewController.create()
        vc2.title = "test2"
        let vcList = [vc1, vc2]
        vcList.forEach { (vc) in
            addViewController(vc: vc, needLabel: vcList.count > 1)
        }
    }
    
    private func addViewController(vc: PullRequestViewController, needLabel: Bool) {
        let selected = tabContentView.subviews.isEmpty
        
        let tabViewItem = NSTabViewItem()
        tabViewItem.viewController = vc
        tabContentView.addTabViewItem(tabViewItem)
        
        if needLabel {
            let tabLabel = NSTextField(labelWithString: vc.title ?? "tab")
            tabLabel.alignment = NSTextAlignment.center
            tabItemContainerView.addArrangedSubview(tabLabel)
            if selected {
                tabLabel.drawsBackground = true
                tabLabel.backgroundColor = vc.backgroundColor()
            }
        } else {
            tabItemContainerHeightConstraint.constant = 0.0
        }
    }
    
    func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
        return NSRect.zero
    }
}
