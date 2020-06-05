//
//  CheckError.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/05.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import Moya

class DecodeJson<T: Codable> {
    private let result: Result<Moya.Response, Moya.MoyaError>
   
    init(result: Result<Moya.Response, Moya.MoyaError>) {
        self.result = result
    }
    
    func decode() throws -> T {
        switch result {
        case let .success(moyaResponse):
            if let error = checkError(response: moyaResponse) {
                throw error
            } else {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: moyaResponse.data)
            }
        case let .failure(error):
            throw error
        }
    }
    
    private func checkError(response: Moya.Response) -> Error? {
        switch response.statusCode {
        case 200:
            return nil
        default:
            return ApiError.serverError(description: response.description)
        }
    }
}
