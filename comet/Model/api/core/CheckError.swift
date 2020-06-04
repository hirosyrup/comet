//
//  CheckError.swift
//  comet
//
//  Created by 岩井 宏晃 on 2020/06/05.
//  Copyright © 2020 koalab. All rights reserved.
//

import Foundation
import Moya

class CheckError {
    static func error(response: Moya.Response) -> Error? {
        switch response.statusCode {
        case 200:
            return nil
        default:
            return ApiError.serverError(description: response.description)
        }
    }
}
