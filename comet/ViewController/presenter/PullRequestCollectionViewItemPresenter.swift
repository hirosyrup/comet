//
//  PullRequestCollectionViewItemPresenter.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/18.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class PullRequestCollectionViewItemPresenter {
    private let data: PullRequestData
    private let unreadCommandPresenter: UnreadCommentPresenter
    
    init(data: PullRequestData) {
        self.data = data
        self.unreadCommandPresenter = UnreadCommentPresenter(data: data)
    }
    
    func hiddenUnreadCommentCount() -> Bool {
        return unreadCommandPresenter.hiddenUnreadCommentCount()
    }
    
    func id() -> Int {
        return data.response.id
    }
    
    func unreadCommentCount() -> String {
        return unreadCommandPresenter.unreadCommentCount()
    }
    
    func commentCount() -> String {
        return "\(data.response.comment_count)"
    }
    
    func authorImageUrl() -> URL? {
        return URL(string: data.response.author.links.avatar.href)
    }
    
    func title() -> String {
        return data.response.title
    }
    
    func hiddenNewCommitNote() -> Bool {
        data.log.openedCommitHash == data.response.source.commit.hash
    }
    
    func newCommitNote() -> String {
        if hiddenNewCommitNote() {
            return ""
        } else {
            return "New commits pushed to the branch."
        }
    }
    
    func reviewerIconContainerViewPresenter() -> ReviewerIconContainerViewPresenter {
        return ReviewerIconContainerViewPresenter(reviewDataList: data.response.participants.filter{ $0.isReviewer() })
    }
}
