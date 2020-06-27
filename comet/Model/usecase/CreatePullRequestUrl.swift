//
//  CreatePullRequestUrl.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/28.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class CreatePullRequestUrl {
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func createUrl() -> URL {
        return URL(string: "https://bitbucket.org/kiizan-kiizan/leeap/pull-requests/\(id)")!
    }
}
