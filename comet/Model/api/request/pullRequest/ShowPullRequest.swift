//
//  ShowPullRequest.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/06.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import Moya

class ShowPullRequest: TargetType {
    
    private let id: Int
    private let repositoryOwner: String
    private let repositorySlug: String
    private let requestHeader: RequestHeader
    
    init(id: Int, repositoryOwner: String, repositorySlug: String, requestHeader: RequestHeader) {
        self.id = id
        self.repositoryOwner = repositoryOwner
        self.repositorySlug = repositorySlug
        self.requestHeader = requestHeader
    }
    
    var baseURL: URL {
        return BaseUrl.url
    }
    
    var path: String {
        return "/repositories/\(repositoryOwner)/\(repositorySlug)/pullrequests/\(id)"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return requestHeader.headers()
    }
}
