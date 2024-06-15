//
//  UserDetails.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import DomainEntities

struct UserProfileResponse: Decodable {
    let email: String

    init(from decoder: Decoder) throws {
        self.email = try decoder.decode("email")
    }
}

extension UserProfileResponse {
    func asAuthenticatedUserEntity() -> AuthenticatedUserEntity {
        return AuthenticatedUserEntity(email: email, phone: nil, username: nil)
    }
}
