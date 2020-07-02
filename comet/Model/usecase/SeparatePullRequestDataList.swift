//
//  SeparatePullRequestDataList.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/07/03.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class SeparatePullRequestDataList {
    private(set) var approvedList = [PullRequestData]()
    private(set) var inReviewList = [PullRequestData]()
    
    init(pullRequestDataList: [PullRequestData]) {
        pullRequestDataList.forEach { pullRequestData in
            let reviewerList = pullRequestData.response.participants.filter {$0.isReviewer()}
            if reviewerList.allSatisfy({$0.approved}) {
                approvedList.append(pullRequestData)
            } else {
                inReviewList.append(pullRequestData)
            }
        }
    }
}
