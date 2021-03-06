//
//  RepositoryTabItemViewPresenter.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/24.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class RepositoryTabItemViewPresenter {
    private let count: Int
    
    init(dataList: [PullRequestData]) {
        let calcUnreadCommentCountList = dataList.map {CalcUnreadCommentCount(data: $0)}
        self.count = calcUnreadCommentCountList.map { $0.unreadCommentCount() }.reduce(0, +)
    }
    
    func hiddenUnreadCommentCount() -> Bool {
        return count <= 0
    }
    
    func unreadCommentCount() -> String {
        return "\(count)"
    }
}
