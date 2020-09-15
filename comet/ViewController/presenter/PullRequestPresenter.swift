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
        let separator = SeparatePullRequestDataList(pullRequestDataList: pullRequestDataList)
        
        var _sectionPresenters = [PullRequestSectionPresenter]()
        if !separator.approvedList.isEmpty {
            _sectionPresenters.append(
                PullRequestSectionPresenter(title: "Approved", pullRequestDataList: separator.approvedList)
            )
        }
        if !separator.inReviewList.isEmpty {
            _sectionPresenters.append(
                PullRequestSectionPresenter(title: "In Review", pullRequestDataList: separator.inReviewList)
            )
        }
        if !separator.mergedList.isEmpty {
            _sectionPresenters.append(
                PullRequestSectionPresenter(title: "Merged", pullRequestDataList: separator.mergedList)
            )
        }
        self.sectionPresenters = _sectionPresenters
    }
}
