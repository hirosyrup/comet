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
    
    init(repositoryOwner: String, repositorySlug: String, userName: String, password: String) {
        self.repositoryOwner = repositoryOwner
        self.repositorySlug = repositorySlug
        self.userName = userName
        self.password = password
    }
    
    func execute() throws -> String {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<Moya.Response, Moya.MoyaError>!
        
        let requestHeader = RequestHeader(userName: userName, password: password)
        let provider = MoyaProvider<FetchPullRequests>()
        provider.request(FetchPullRequests(repositoryOwner: repositoryOwner, repositorySlug: repositorySlug, requestHeader: requestHeader)) { _result in
            result = _result
            semaphore.signal()
        }
        semaphore.wait()
        switch result {
        case let .success(moyaResponse):
            if let error = CheckError.error(response: moyaResponse) {
                throw error
            } else {
                let decoder = JSONDecoder()
                let json = try decoder.decode(FetchPullRequestResponse.self, from: moyaResponse.data)
                return "\(json)"
            }
        case let .failure(error):
            throw error
        case .none:
            throw ApiError.noneResult
        }
    }
}
