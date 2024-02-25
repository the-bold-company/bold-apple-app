//
//  CredentialsEntity.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

public struct CredentialsEntity: Equatable {
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
