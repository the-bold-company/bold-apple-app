//
//  LoginResponse.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

// TODO: Move Equatable conformation to an entity
public struct LoginResponse: Decodable, Equatable {
    public let token: String
    public let refreshToken: String
    public let user: UserDetails

    public init(from decoder: Decoder) throws {
        self.token = try decoder.decode("token")
        self.refreshToken = try decoder.decode("refreshToken")
        self.user = try decoder.decode("user")
    }
}
