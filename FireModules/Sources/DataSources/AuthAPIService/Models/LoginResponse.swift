//
//  LoginResponse.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import DomainEntities

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let idToken: String
    let profile: UserProfileResponse

    init(from decoder: Decoder) throws {
        self.accessToken = try decoder.decode("accessToken")
        self.refreshToken = try decoder.decode("refreshToken")
        self.idToken = try decoder.decode("idToken")
        self.profile = try decoder.decode("profile")
    }
}

extension LoginResponse {
    func asCredentialsEntity() -> CredentialsEntity {
        return CredentialsEntity(accessToken: accessToken, refreshToken: refreshToken, idToken: idToken)
    }
}
