//
//  PullRequestCollectionViewItem.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/05/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

protocol PullRequestCollectionViewItemDelegate: class {
    func didPushReadButton(view: PullRequestCollectionViewItem, id: Int)
}

class PullRequestCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var background: NSBox!
    @IBOutlet weak var unreadCommentCountBadge: NSBox!
    @IBOutlet weak var unreadCommentCountLabel: NSTextField!
    @IBOutlet weak var newCommitNoteLabel: NSTextField!
    @IBOutlet weak var commentCountLabel: NSTextField!
    @IBOutlet weak var authorImageView: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var reviewerIconView: ReviewerIconContainerView!
    
    weak var delegate: PullRequestCollectionViewItemDelegate?
    private var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.addTrackingArea(NSTrackingArea(rect: view.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: view, userInfo: nil))
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        authorImageView.wantsLayer = true
        authorImageView.layer?.cornerRadius = authorImageView.bounds.width / 2.0
    }
    
    override func mouseEntered(with event: NSEvent) {
        background.isTransparent = false
        background.fillColor = NSColor.cellBackground
    }
    
    override func mouseExited(with event: NSEvent) {
        background.isTransparent = true
        background.fillColor = NSColor.clear
    }
    
    func updateView(presenter: PullRequestCollectionViewItemPresenter) {
        id = presenter.id()
        unreadCommentCountBadge.isHidden = presenter.hiddenUnreadCommentCount()
        unreadCommentCountLabel.stringValue = presenter.unreadCommentCount()
        newCommitNoteLabel.isHidden = presenter.hiddenNewCommitNote()
        newCommitNoteLabel.stringValue = presenter.newCommitNote()
        commentCountLabel.stringValue = presenter.commentCount()
        if let authorImageUrl = presenter.authorImageUrl() {
            authorImageView.loadImageAsynchronously(url: authorImageUrl)
        }
        titleLabel.stringValue = presenter.title()
        reviewerIconView.updateView(presenter: presenter.reviewerIconContainerViewPresenter())
    }
    
    @IBAction func pushReadButton(_ sender: Any) {
        delegate?.didPushReadButton(view: self, id: id)
    }
}
