//
//  AuthAPI.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import Moya

enum AuthAPI {
    case login(email: String, password: String)
    case register(email: String, password: String)
}

extension AuthAPI: BaseTargetType {
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        }
    }

    var method: Method {
        switch self {
        case .login, .register:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .login(email, password),
             let .register(email, password):
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
