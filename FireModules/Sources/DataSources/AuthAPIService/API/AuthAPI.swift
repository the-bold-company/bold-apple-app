//
//  AuthAPI.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import Moya

enum AuthAPI {
    enum v0 {
        case login(email: String, password: String)
        case register(email: String, password: String)
    }

    enum v1 {
        case logIn(email: String, password: String)
        case signUp(email: String, password: String)
        case otp(email: String, code: String)
        case verifyEmailExistence(email: String)
        case forgotPassword(email: String)
        case confirmResetPassword(email: String, password: String, code: String)
    }
}

extension AuthAPI.v0: BaseTargetType {
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
                encoding: JSONEncoding.default
            )
        }
    }
}

extension AuthAPI.v1: BaseTargetType {
    var path: String {
        switch self {
        case .logIn:
            return "/auth/sign-in-web"
        case .signUp:
            return "/auth/sign-up"
        case .otp:
            return "/auth/confirm-sign-up"
        case .verifyEmailExistence:
            return "/auth/check-email"
        case .forgotPassword:
            return "/auth/forgot-password"
        case .confirmResetPassword:
            return "/auth/confirm-forgot-password"
        }
    }

    var method: Method {
        switch self {
        case .logIn, .signUp, .otp, .verifyEmailExistence, .forgotPassword,
             .confirmResetPassword:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .logIn(email, password),
             let .signUp(email, password):
            return .requestParameters(
                parameters: [
                    "email": email,
                    "password": password,
                ],
                encoding: JSONEncoding.default
            )
        case let .otp(email, code):
            return .requestParameters(
                parameters: [
                    "email": email,
                    "confirmationCode": code,
                ],
                encoding: JSONEncoding.default
            )
        case let .verifyEmailExistence(email),
             let .forgotPassword(email):
            return .requestParameters(
                parameters: [
                    "email": email,
                ],
                encoding: JSONEncoding.default
            )
        case let .confirmResetPassword(email, password, code):
            return .requestParameters(
                parameters: [
                    "email": email,
                    "password": password,
                    "confirmationCode": code,
                ],
                encoding: JSONEncoding.default
            )
        }
    }
}
