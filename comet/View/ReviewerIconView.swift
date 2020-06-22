//
//  ReviewerIconView.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/22.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class ReviewerIconView: NSView {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var checkImageView: NSImageView!
    
    static func createFromNib(owner: Any?) -> ReviewerIconView? {
        var objects: NSArray? = NSArray()
        NSNib(nibNamed: "ReviewerIconView", bundle: nil)?.instantiate(withOwner: owner, topLevelObjects: &objects)
        return objects?.first{ $0 is ReviewerIconView } as? ReviewerIconView
    }
    
    func setCornerRadius(radius: CGFloat) {
        iconImageView.wantsLayer = true
        iconImageView.layer?.cornerRadius = radius - topConstraint.constant
    }
    
    func updateView(presenter: ReviewerIconViewPresenter) {
        checkImageView.isHidden = !presenter.approved()
        iconImageView.loadImageAsynchronously(url: presenter.imageUrl())
    }
}
