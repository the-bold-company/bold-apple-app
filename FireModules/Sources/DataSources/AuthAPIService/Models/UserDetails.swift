//
//  UserDetails.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import DomainEntities

struct UserDetails: Decodable {
    let username: String?
    let email: String
    let accountType: String?
    let phone: String?

    init(from decoder: Decoder) throws {
        self.username = try decoder.decodeIfPresent("username")
        self.email = try decoder.decode("email")
        self.accountType = try decoder.decodeIfPresent("accountType")
        self.phone = try decoder.decodeIfPresent("phone")
    }
}

extension UserDetails {
    func asAuthenticatedUserEntity() -> AuthenticatedUserEntity {
        return AuthenticatedUserEntity(email: email, phone: phone, username: username)
    }
}
