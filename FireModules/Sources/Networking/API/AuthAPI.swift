//
//  AuthAPI.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import Moya

enum AuthAPI {
    case login(email: String, password: String)
}

extension AuthAPI: BaseTargetType {
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        }
    }

    var method: Method {
        switch self {
        case .login:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .login(email, password):
            return .requestParameters(
                parameters: [
                    "email": email,
                    "password": password,
                ],
                encoding: URLEncoding.default
            )
        }
    }
}
