//
//  FetchPullRequestResponse.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/05.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

struct FetchPullRequestResponse: Codable {
    let page: Int
    let pagelen: Int
    let size: Int
    let values: [PullRequestValue]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case pagelen
        case size
        case values
    }
}
