//
//  CallShowPullRequest.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/06.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import Moya

class CallShowPullRequest {
    private let id: Int
    private let repositoryOwner: String
    private let repositorySlug: String
    private let userName: String
    private let password: String
    
    init(id: Int, repositoryOwner: String, repositorySlug: String, userName: String, password: String) {
        self.id = id
        self.repositoryOwner = repositoryOwner
        self.repositorySlug = repositorySlug
        self.userName = userName
        self.password = password
    }
    
    func execute() throws -> ShowPullRequestResponse {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Moya.Response, Moya.MoyaError>!
        
        let requestHeader = RequestHeader(userName: userName, password: password)
        let provider = MoyaProvider<ShowPullRequest>()
        provider.request(ShowPullRequest(id: id, repositoryOwner: repositoryOwner, repositorySlug: repositorySlug, requestHeader: requestHeader)) { _result in
            result = _result
            semaphore.signal()
        }
        semaphore.wait()
        return try DecodeJson<ShowPullRequestResponse>(result: result).decode()
    }
}
