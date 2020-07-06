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
        try! data.log.saveCommentCount(openedCommentCount: data.response.comment_count, unreadCommentCountAtPreviousNotification: 0)
        try! data.log.saveCommitHash(openedCommitHash: data.response.source.commit.hash, commitHashAtPreviousNotification: data.log.commitHashAtPreviousNotification)
    }
    
    func updateToNotifiedStatusForNewComment() {
        try! data.log.saveCommentCount(openedCommentCount: data.log.openedCommentCount, unreadCommentCountAtPreviousNotification: calcUnreadCommentCount.unreadCommentCount())
    }
    
    func updateToNotifiedStatusForNewCommit() {
        try! data.log.saveCommitHash(openedCommitHash: data.log.openedCommitHash, commitHashAtPreviousNotification: data.response.source.commit.hash)
    }
}
