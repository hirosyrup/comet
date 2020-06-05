//
//  PullRequestVallue.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/05.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

struct PullRequestValue: Codable {
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
}
