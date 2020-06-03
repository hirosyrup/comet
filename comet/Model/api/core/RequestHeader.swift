//
//  RequestHeader.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/03.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

class RequestHeader {
    private let userName: String
    private let password: String
    
    init(userName: String, password: String) {
        self.userName = userName
        self.password = password
    }
    
    func headers() -> [String : String]? {
        let plainString = "\(userName):\(password)" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        return [
            "Content-type": "application/json",
            "Authorization": "Basic " + base64String!
        ]
    }
}
