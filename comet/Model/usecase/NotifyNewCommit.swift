//
//  NotifyNewCommit.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/07/06.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import UserNotifications

class NotifyNewCommit {
    private let dataList: [PullRequestData]
    
    init(dataList: [PullRequestData]) {
        self.dataList = dataList
    }
    
    func notify() {
        let targetList = filterTargetDataList()
        guard !targetList.isEmpty else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "comet"
        content.body = createNotificationMessage(targetList: targetList)
        content.sound = .default
        let request = UNNotificationRequest(identifier: "New Commit Notification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    targetList.forEach { UpdatePullRequestLog(data: $0).updateToNotifiedStatusForNewCommit() }
                }
            }
        }
    }
    
    private func filterTargetDataList() -> [PullRequestData] {
        return dataList.filter {
            return $0.log.commitHashAtPreviousNotification != $0.response.source.commit.hash
        }
    }
    
    private func createNotificationMessage(targetList: [PullRequestData]) -> String {
        if targetList.count == 1 {
            return "New commits pushed on a pull request"
        } else {
            return "New commits pushed on pull requests"
        }
    }
}
