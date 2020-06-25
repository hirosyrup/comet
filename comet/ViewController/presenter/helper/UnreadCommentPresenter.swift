//
//  UnreadCommentPresenter.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/24.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class UnreadCommentPresenter {
    private let calcUnreadCommentCount: CalcUnreadCommentCount
    
    init(data: PullRequestData) {
        self.calcUnreadCommentCount = CalcUnreadCommentCount(data: data)
    }
    
    func hiddenUnreadCommentCount() -> Bool {
        return calcUnreadCommentCount.unreadCommentCount() <= 0
    }
    
    func unreadCommentCount() -> String {
        return "\(calcUnreadCommentCount.unreadCommentCount())"
    }
}
