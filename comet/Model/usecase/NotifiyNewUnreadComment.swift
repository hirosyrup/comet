//
//  NotifiyNewUnreadComment.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/25.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import UserNotifications

class NotifyNewUnreadComment {
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
        let request = UNNotificationRequest(identifier: "New Unread Comment Notification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    targetList.forEach { UpdatePullRequestLog(data: $0).updateToNotifiedStatus() }
                }
            }
        }
    }
    
    private func filterTargetDataList() -> [PullRequestData] {
        return dataList.filter {
            guard let log = $0.log else { return true }
            let calcUnreadCommentCount = CalcUnreadCommentCount(data: $0)
            return log.unreadCommentCountAtPreviousNotification != calcUnreadCommentCount.unreadCommentCount()
        }
    }
    
    private func createNotificationMessage(targetList: [PullRequestData]) -> String {
        if targetList.count == 1 {
            return "New comment posted on a pull request"
        } else {
            return "New comment posted on pull requests"
        }
    }
}
