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
    
    private var iconViewList = [NSImageView]()
    private let padding: CGFloat = 8.0
    
    func updateView(presenter: ReviewerIconContainerViewPresenter) {
        let imageUrlList = presenter.imageUrlList()
        iconViewList.forEach { $0.removeFromSuperview() }
        let imageViewSize = heightConstraint.constant - padding * 2.0
        let offset = imageUrlList.count == 1 ? 0 : (widthConstraint.constant - (imageViewSize * CGFloat(imageUrlList.count))) / CGFloat(imageUrlList.count - 1)
        iconViewList = imageUrlList.enumerated().map {
            let imageView = NSImageView()
            let x = (imageViewSize + offset) * CGFloat($0.offset)
            imageView.frame = NSRect(x: x, y: padding, width: imageViewSize, height: imageViewSize)
            imageView.wantsLayer = true
            imageView.layer?.cornerRadius = imageViewSize / 2.0
            imageView.loadImageAsynchronously(url: $0.element)
            addSubview(imageView)
            return imageView
        }
    }
}
