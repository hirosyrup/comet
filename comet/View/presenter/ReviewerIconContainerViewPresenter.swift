//
//  ReviewerIconContainerViewPresenter.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/21.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class ReviewerIconContainerViewPresenter {
    private let reviewDataList: [PullRequestParticipant]
    
    init(reviewDataList: [PullRequestParticipant]) {
        self.reviewDataList = reviewDataList
    }
    
    func imageUrlList() -> [URL] {
        return reviewDataList.compactMap {
            return URL(string: $0.user.links.avatar.href)
        }
    }
}
