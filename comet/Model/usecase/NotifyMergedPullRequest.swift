//
//  NotifyMergedPullRequest.swift
//  comet
//
//  Created by 岩井宏晃 on 2020/09/15.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

import UserNotifications

class NotifyMergedPullRequest {
    private let pullRequestTitle: String
    
    init(pullRequestTitle: String) {
        self.pullRequestTitle = pullRequestTitle
    }
    
    func notify() {
        let content = UNMutableNotificationContent()
        content.title = "A pull request was merged"
        content.body = pullRequestTitle
        content.sound = .default
        let request = UNNotificationRequest(identifier: "Merged Pull Request Notification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
