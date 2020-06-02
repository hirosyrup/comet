//
//  BitbucketRequest.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/02.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import Moya

enum BitbucketRequest{
    case indexPullRequests(repositoryOwner: String, repositorySlug: String)
}

extension BitbucketRequest: TargetType {
    var baseURL: URL {
        return URL(string: "https://bitbucket.org/api/2.0")!
    }
    
    var path: String {
        switch self {
        case .indexPullRequests(let repositoryOwner, let repositorySlug):
            return "/repositories/\(repositoryOwner)/\(repositorySlug)/pullrequests/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .indexPullRequests:
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .indexPullRequests:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let plainString = "hirosyrup:nzqnVPQ8dtyeecMDBXfc" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        return [
            "Content-type": "application/json",
            "Authorization": "Basic " + base64String!
        ]
    }
}
