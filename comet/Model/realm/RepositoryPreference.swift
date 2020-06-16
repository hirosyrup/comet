//
//  RepositoryPreference.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/16.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import RealmSwift

class RepositoryPreference: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var user: User!
    @objc dynamic var owner = ""
    @objc dynamic var slug = ""
    @objc dynamic var createdAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func all() throws -> RealmSwift.Results<RepositoryPreference> {
        let realm = try Realm()
        return realm.objects(RepositoryPreference.self).sorted(byKeyPath: "createdAt")
    }
    
    func save(user: User, owner: String, slug: String) throws {
        let realm = try Realm()
        try realm.write{
            self.user = user
            self.owner = owner
            self.slug = slug
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
