//
//  ShowPullRequestResponse.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/06.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

struct ShowPullRequestResponse: Codable {
    let id: Int
    let participants: [PullRequestParticipant]
}
