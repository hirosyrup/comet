//
//  UnreadCommentPresenter.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/24.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class UnreadCommentPresenter {
    private let data: PullRequestData
    
    init(data: PullRequestData) {
        self.data = data
    }
    
    func hiddenUnreadCommentCount() -> Bool {
        return unreadCommentCountInt() <= 0
    }
    
    func unreadCommentCount() -> String {
        return "\(unreadCommentCountInt())"
    }
    
    func unreadCommentCountInt() -> Int {
        if let log = data.log {
            return data.response.comment_count - log.openedCommentCount
        } else {
            return data.response.comment_count
        }
    }
}
