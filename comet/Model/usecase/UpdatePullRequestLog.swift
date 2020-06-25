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
        let log = pullRequestLog()
        try! log.save(id: log.id, openedCommentCount: data.response.comment_count, unreadCommentCountAtPreviousNotification: 0)
    }
    
    func updateToNotifiedStatus() {
        let log = pullRequestLog()
        try! log.save(id: log.id, openedCommentCount: log.openedCommentCount, unreadCommentCountAtPreviousNotification: calcUnreadCommentCount.unreadCommentCount())
    }
    
    private func pullRequestLog() -> PullRequetLog {
        if let log = data.log {
            return log
        } else {
            let newLog = PullRequetLog()
            newLog.id = data.response.id
            return newLog
        }
    }
}
