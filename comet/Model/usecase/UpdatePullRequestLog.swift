//
//  UpdatePullRequestLog.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class UpdatePullRequestLog {
    private let data: PullRequestData
    private let calcUnreadCommentCount: CalcUnreadCommentCount
    
    init(data: PullRequestData) {
        self.data = data
        self.calcUnreadCommentCount = CalcUnreadCommentCount(data: data)
    }
    
    func updateToReadAll() {
        try! data.log.save(openedCommentCount: data.response.comment_count, unreadCommentCountAtPreviousNotification: 0)
    }
    
    func updateToNotifiedStatus() {
        try! data.log.save(openedCommentCount: data.log.openedCommentCount, unreadCommentCountAtPreviousNotification: calcUnreadCommentCount.unreadCommentCount())
    }
}
