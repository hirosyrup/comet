//
//  Migration.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/07/06.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import RealmSwift

class Migration {
    func execute() {
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: nil)
        
        Realm.Configuration.defaultConfiguration = config
    }
}
