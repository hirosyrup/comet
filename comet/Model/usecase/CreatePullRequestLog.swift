//
//  CreatePullRequestLog.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/07/06.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class CreatePullRequestLog {
    func createNewLog(id: Int, fetchedCommitHash: String) -> PullRequestLog{
        let newLog = PullRequestLog()
        try! newLog.create(id: id)
        try! newLog.saveCommitHash(openedCommitHash: "", commitHashAtPreviousNotification: fetchedCommitHash)
        return newLog
    }
}
