//
//  PullRequestReviewer.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/06.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class PullRequestParticipant: Codable {
    let approved: Bool
    let role: String
    let user: PullRequestParticipantUser
}
