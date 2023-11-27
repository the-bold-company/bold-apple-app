//
//  LoginResponse.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

public struct LoginReponse: Decodable {
    public let token: String
    public let refreshToken: String
    public let user: UserDetails

    public init(from decoder: Decoder) throws {
        self.token = try decoder.decode("token")
        self.refreshToken = try decoder.decode("refreshToken")
        self.user = try decoder.decode("user")
    }
}
