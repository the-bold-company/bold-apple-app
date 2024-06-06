//
//  LoginResponse.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import DomainEntities

struct LoginResponse: Decodable {
    let token: String
    let refreshToken: String
    let user: UserDetails

    init(from decoder: Decoder) throws {
        self.token = try decoder.decode("token")
        self.refreshToken = try decoder.decode("refreshToken")
        self.user = try decoder.decode("user")
    }
}

extension LoginResponse {
    func asCredentialsEntity() -> CredentialsEntity {
        return CredentialsEntity(accessToken: token, refreshToken: refreshToken)
    }
}
