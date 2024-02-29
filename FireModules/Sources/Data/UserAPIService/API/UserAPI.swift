//
//  UserAPI.swift
//
//
//  Created by Hien Tran on 07/12/2023.
//

import Networking

enum UserAPI {
    case signUp(email: String, password: String)
}

extension UserAPI: BaseTargetType {
    var path: String {
        switch self {
        case .signUp:
            return "/users/register"
        }
    }

    var method: Method {
        switch self {
        case .signUp:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .signUp(email, password):
            return .requestParameters(
                parameters: [
                    "email": email,
                    "password": password,
                    // "accountType": "personal",
                    // "phone": "63123456789"
                ],
                encoding: JSONEncoding.default
            )
        }
    }
}
