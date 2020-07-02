//
//  NotifyNewPullRequest.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/07/02.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

import UserNotifications

class NotifyNewPullRequest {
    private let pullRequestTitle: String
    
    init(pullRequestTitle: String) {
        self.pullRequestTitle = pullRequestTitle
    }
    
    func notify() {
        let content = UNMutableNotificationContent()
        content.title = "A pull request was created"
        content.body = pullRequestTitle
        content.sound = .default
        let request = UNNotificationRequest(identifier: "New Pull Request Notification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
