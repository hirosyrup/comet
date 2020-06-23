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
    
    init(data: PullRequestData) {
        self.data = data
    }
    
    func hiddenUnreadCommentCount() -> Bool {
        return unreadCommentCountInt() <= 0
    }
    
    func unreadCommentCount() -> String {
        return "\(unreadCommentCountInt())"
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
    
    func reviewerIconContainerViewPresenter() -> ReviewerIconContainerViewPresenter {
        return ReviewerIconContainerViewPresenter(reviewDataList: data.response.participants.filter{ $0.isReviewer() })
    }
    
    private func unreadCommentCountInt() -> Int {
        if let log = data.log {
            return data.response.comment_count - log.openedCommentCount
        } else {
            return data.response.comment_count
        }
    }
}
