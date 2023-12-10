//
//  AuthRepository.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import Combine
import CombineExt
import CombineMoya

// TODO: Can we create this with Sourcery?
public struct AuthAPIService {
    let client = MoyaClient<AuthAPI>()

    public init() {}

    public func login(email: String, password: String) -> AnyPublisher<Result<LoginResponse, NetworkError>, Never> {
        return client
            .requestPublisher(.login(email: email, password: password))
            .mapToResponse(LoginResponse.self)
            .mapToResult()
    }
}
