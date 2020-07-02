//
//  AppDelegatePresenter.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/07/03.
//  Copyright © 2020 koalab. All rights reserved.
//

import Cocoa

class AppDelegatePresenter {
    private let unreadCommentCount: Int
    private let inReviewCount: Int
    
    init(unreadCommentCount: Int, inReviewCount: Int) {
        self.unreadCommentCount = unreadCommentCount
        self.inReviewCount = inReviewCount
    }
    
    func textInStatusMenu() -> NSAttributedString {
        let unreadCommentCountText = NSAttributedString(string: unreadCommentCount == 0 ? "" : "\(unreadCommentCount)", attributes: [NSAttributedString.Key.foregroundColor: NSColor.red])
        let inReviewCountText = NSAttributedString(string: inReviewCount == 0 ? "" : "\(inReviewCount)")
            
        let texts = [unreadCommentCountText, inReviewCountText].filter {$0.length != 0}
        return texts.count > 1 ? texts.joined(with: "|") : (texts.first ?? NSAttributedString(string: ""))
    }
}
