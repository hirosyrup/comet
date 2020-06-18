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
    
    func commentCount() -> String {
        return "\(data.response.comment_count)"
    }
    
    func authorImageUrl() -> URL? {
        return URL(string: data.response.author.links.avatar.href)
    }
    
    func title() -> String {
        return data.response.title
    }
}
