//
//  BitbucketRequest.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/02.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import Moya

class FetchPullRequest: TargetType {
    
    private let repositoryOwner: String
    private let repositorySlug: String
    private let requestHeader: RequestHeader
    
    init(repositoryOwner: String, repositorySlug: String, requestHeader: RequestHeader) {
        self.repositoryOwner = repositoryOwner
        self.repositorySlug = repositorySlug
        self.requestHeader = requestHeader
    }
    
    var baseURL: URL {
        return BaseUrl.url
    }
    
    var path: String {
        return "/repositories/\(repositoryOwner)/\(repositorySlug)/pullrequests/"
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
