//
//  UserDetails.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

public struct UserDetails: Decodable {
    let username: String?
    let email: String
    let accountType: String
    let phone: String

    public init(from decoder: Decoder) throws {
        self.username = try decoder.decodeIfPresent("username")
        self.email = try decoder.decode("email")
        self.accountType = try decoder.decode("accountType")
        self.phone = try decoder.decode("phone")
    }
}
