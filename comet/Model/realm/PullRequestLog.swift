//
//  PullRequest.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/18.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import RealmSwift

class PullRequestLog: Object {
    @objc dynamic var id = 0
    @objc dynamic var openedCommentCount = 0
    @objc dynamic var unreadCommentCountAtPreviousNotification = 0
    @objc dynamic var openedCommitHash = ""
    @objc dynamic var commitHashAtPreviousNotification = ""
    @objc dynamic var createdAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func all() throws -> RealmSwift.Results<PullRequestLog> {
        let realm = try Realm()
        return realm.objects(PullRequestLog.self).sorted(byKeyPath: "createdAt")
    }
    
    func create(id: Int) throws {
        let realm = try Realm()
        try realm.write{
            self.id = id
            realm.add(self)
        }
    }
    
    func saveCommentCount(openedCommentCount: Int, unreadCommentCountAtPreviousNotification: Int) throws {
        let realm = try Realm()
        try realm.write{
            self.openedCommentCount = openedCommentCount
            self.unreadCommentCountAtPreviousNotification = unreadCommentCountAtPreviousNotification
            realm.add(self, update: .modified)
        }
    }
    
    func saveCommitHash(openedCommitHash: String, commitHashAtPreviousNotification: String) throws {
        let realm = try Realm()
        try realm.write{
            self.openedCommitHash = openedCommitHash
            self.commitHashAtPreviousNotification = commitHashAtPreviousNotification
            realm.add(self, update: .modified)
        }
    }
}
