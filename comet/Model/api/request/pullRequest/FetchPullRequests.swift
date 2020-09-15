//
//  BitbucketRequest.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/02.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import Moya

class FetchPullRequests: TargetType {
    
    private let repositoryOwner: String
    private let repositorySlug: String
    private let requestHeader: RequestHeader
    private let merged: Bool
    
    init(repositoryOwner: String, repositorySlug: String, requestHeader: RequestHeader, merged: Bool) {
        self.repositoryOwner = repositoryOwner
        self.repositorySlug = repositorySlug
        self.requestHeader = requestHeader
        self.merged = merged
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
        if merged {
            var params: [String : Any] = [:]
            params["state"] = "MERGED"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        } else {
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return requestHeader.headers()
    }
}
