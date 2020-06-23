//
//  ReviewerIconViewPresenter.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/22.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class ReviewerIconViewPresenter {
    private let reviewerData: PullRequestParticipant
    
    init(reviewerData: PullRequestParticipant) {
        self.reviewerData = reviewerData
    }
    
    func imageUrl() -> URL {
        return URL(string: reviewerData.user.links.avatar.href)!
    }
    
    func approved() -> Bool {
        return reviewerData.approved
    }
}
