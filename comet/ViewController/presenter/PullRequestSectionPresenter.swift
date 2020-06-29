//
//  PullRequestSectionPresenter.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/29.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class PullRequestSectionPresenter {
    let title: String
    let itemPresenterList: [PullRequestCollectionViewItemPresenter]
    
    init(title: String, pullRequestDataList: [PullRequestData]) {
        self.title = title
        self.itemPresenterList = pullRequestDataList.map { PullRequestCollectionViewItemPresenter(data: $0) }
    }
}
