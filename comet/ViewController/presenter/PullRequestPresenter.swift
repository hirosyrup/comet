//
//  PullRequestPresenter.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/29.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class PullRequestPresenter {
    let sectionPresenters: [PullRequestSectionPresenter]
    
    init(pullRequestDataList: [PullRequestData]) {
        var approvedList = [PullRequestData]()
        var inReviewList = [PullRequestData]()
        pullRequestDataList.forEach { pullRequestData in
            let reviewerList = pullRequestData.response.participants.filter {$0.isReviewer()}
            if reviewerList.allSatisfy({$0.approved}) {
                approvedList.append(pullRequestData)
            } else {
                inReviewList.append(pullRequestData)
            }
        }
        
        var _sectionPresenters = [PullRequestSectionPresenter]()
        if !approvedList.isEmpty {
            _sectionPresenters.append(
                PullRequestSectionPresenter(title: "Approved", pullRequestDataList: approvedList)
            )
        }
        if !inReviewList.isEmpty {
            _sectionPresenters.append(
                PullRequestSectionPresenter(title: "In Review", pullRequestDataList: inReviewList)
            )
        }
        self.sectionPresenters = _sectionPresenters
    }
}
