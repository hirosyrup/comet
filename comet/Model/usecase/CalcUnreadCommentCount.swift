//
//  CalcUnreadCommentCount.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class CalcUnreadCommentCount {
    private let data: PullRequestData
    
    init(data: PullRequestData) {
        self.data = data
    }
    
    func unreadCommentCount() -> Int {
        if let log = data.log {
            return data.response.comment_count - log.openedCommentCount
        } else {
            return data.response.comment_count
        }
    }
}
