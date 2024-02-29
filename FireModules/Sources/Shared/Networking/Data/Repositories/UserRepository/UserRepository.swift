//
//  UserRepository.swift
//
//
//  Created by Hien Tran on 07/12/2023.
//

import Combine
import CombineExt
import CombineMoya

struct UserAPIService {
    let client = MoyaClient<UserAPI>()

    init() {}

    func signUp(email: String, password: String) async throws -> LoginResponse {
        return try await client
            .requestPublisher(.signUp(email: email, password: password))
            .mapToResponse(LoginResponse.self)
            .async()
    }
}
