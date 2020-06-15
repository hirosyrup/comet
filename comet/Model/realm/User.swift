//
//  User.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/15.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var password = ""
    @objc dynamic var createdAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func all() throws -> RealmSwift.Results<User> {
        let realm = try Realm()
        return realm.objects(User.self).sorted(byKeyPath: "createdAt")
    }
    
    func save(name: String, password: String) throws {
        let realm = try Realm()
        try realm.write{
            self.name = name
            self.password = password
            realm.add(self, update: .modified)
        }
    }
    
    func delete() throws {
        let realm = try Realm()
        try realm.write{
            realm.delete(self)
        }
    }
}
