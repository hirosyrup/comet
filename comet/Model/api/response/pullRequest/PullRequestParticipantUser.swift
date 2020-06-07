//
//  PullRequestParticipantUser.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/07.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class PullRequestParticipantUser: Codable {
    let account_id: String
    let display_name: String
    let links: PullRequestParticipantUserLinks
}
