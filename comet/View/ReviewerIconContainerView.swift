//
//  ReviewerIconView.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/21.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class ReviewerIconContainerView: NSBox {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    private let iconDefaultOffset: CGFloat = -20.0
    private var iconViewList = [ReviewerIconView]()
    
    func updateView(presenter: ReviewerIconContainerViewPresenter) {
        let reviewIconViewPresenterList = presenter.reviewerIconViewPresenterList()
        iconViewList.forEach { $0.removeFromSuperview() }
        let imageViewSize = heightConstraint.constant
        let listCount = reviewIconViewPresenterList.count
        let offset = imageViewSize * CGFloat(listCount) + iconDefaultOffset * CGFloat(listCount - 1) > widthConstraint.constant ? (widthConstraint.constant - (imageViewSize * CGFloat(listCount))) / CGFloat(listCount - 1) : iconDefaultOffset
        iconViewList = reviewIconViewPresenterList.enumerated().compactMap {
            guard let reviewerIconView = ReviewerIconView.createFromNib(owner: self) else { return nil }
            let x = (imageViewSize + offset) * CGFloat($0.offset)
            reviewerIconView.frame = NSRect(x: x, y: 0.0, width: imageViewSize, height: imageViewSize)
            reviewerIconView.setCornerRadius(radius: imageViewSize / 2.0)
            reviewerIconView.updateView(presenter: $0.element)
            return reviewerIconView
        }
        iconViewList.reversed().forEach { addSubview($0) }
    }
}
