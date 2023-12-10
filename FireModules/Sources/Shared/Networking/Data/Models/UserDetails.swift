//
//  UserDetails.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

// TODO: Move Equatable conformation to an entity
public struct UserDetails: Decodable, Equatable {
    let username: String?
    let email: String
    let accountType: String?
    let phone: String?

    public init(from decoder: Decoder) throws {
        self.username = try decoder.decodeIfPresent("username")
        self.email = try decoder.decode("email")
        self.accountType = try decoder.decodeIfPresent("accountType")
        self.phone = try decoder.decodeIfPresent("phone")
    }
}
