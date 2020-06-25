//
//  PullRequest.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/18.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import RealmSwift

class PullRequetLog: Object {
    @objc dynamic var id = 0
    @objc dynamic var openedCommentCount = 0
    @objc dynamic var unreadCommentCountAtPreviousNotification = 0
    @objc dynamic var createdAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func all() throws -> RealmSwift.Results<PullRequetLog> {
        let realm = try Realm()
        return realm.objects(PullRequetLog.self).sorted(byKeyPath: "createdAt")
    }
    
    func save(id: Int, openedCommentCount: Int, unreadCommentCountAtPreviousNotification: Int) throws {
        let realm = try Realm()
        try realm.write{
            self.id = id
            self.openedCommentCount = openedCommentCount
            self.unreadCommentCountAtPreviousNotification = unreadCommentCountAtPreviousNotification
            realm.add(self, update: .modified)
        }
    }
}
