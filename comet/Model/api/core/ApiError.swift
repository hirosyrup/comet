//
//  ApiError.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/05.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case noneResult
    case serverError(description: String)
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noneResult:
            return "The request has no result."
        case .serverError(let description):
            return description
        }
    }
}
