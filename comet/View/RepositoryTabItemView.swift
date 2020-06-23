//
//  RepositoryTabItemView.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/24.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

protocol RepositoryTabItemViewDelegate: class {
    func didClickTab(view: RepositoryTabItemView)
}

class RepositoryTabItemView: NSView {
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var unreadCommentCountBadge: NSBox!
    @IBOutlet weak var unreadCommentCountLabel: NSTextField!
    
    private(set) var title = ""
    private(set) var index = 0
    weak var delegate: RepositoryTabItemViewDelegate?
    
    static func createFromNib(owner: Any?, title: String, index: Int) -> RepositoryTabItemView {
        var objects: NSArray? = NSArray()
        NSNib(nibNamed: "RepositoryTabItemView", bundle: nil)?.instantiate(withOwner: owner, topLevelObjects: &objects)
        let view = objects!.first{ $0 is RepositoryTabItemView }! as! RepositoryTabItemView
        view.index = index
        view.title = title
        view.setupView()
        return view
    }
    
    private func setupView() {
        addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(clickTab(gesture:))))
        titleLabel.stringValue = title
        unreadCommentCountBadge.isHidden = true
    }
    
    func updateView(presenter: RepositoryTabItemViewPresenter) {
        unreadCommentCountBadge.isHidden = presenter.hiddenUnreadCommentCount()
        unreadCommentCountLabel.stringValue = presenter.unreadCommentCount()
    }
    
    @objc func clickTab(gesture: NSClickGestureRecognizer) {
        delegate?.didClickTab(view: self)
    }
}
