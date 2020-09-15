//
//  CallFetchPullRequests.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/05.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import Moya

class CallFetchPullRequests {
    private let repositoryOwner: String
    private let repositorySlug: String
    private let userName: String
    private let password: String
    private let merged: Bool
    
    init(repositoryOwner: String, repositorySlug: String, userName: String, password: String, merged: Bool) {
        self.repositoryOwner = repositoryOwner
        self.repositorySlug = repositorySlug
        self.userName = userName
        self.password = password
        self.merged = merged
    }
    
    func execute() throws -> FetchPullRequestResponse {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Moya.Response, Moya.MoyaError>!
        
        let requestHeader = RequestHeader(userName: userName, password: password)
        let provider = MoyaProvider<FetchPullRequests>()
        provider.request(FetchPullRequests(repositoryOwner: repositoryOwner, repositorySlug: repositorySlug, requestHeader: requestHeader, merged: merged)) { _result in
            result = _result
            semaphore.signal()
        }
        semaphore.wait()
        return try DecodeJson<FetchPullRequestResponse>(result: result).decode()
    }
}
