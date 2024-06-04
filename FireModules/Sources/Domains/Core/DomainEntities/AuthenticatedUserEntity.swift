//
//  AuthenticatedUserEntity.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

public struct AuthenticatedUserEntity: Equatable {
    let email: String // TODO: Create email entity
    let phone: String? // TODO: Create phone entity
    let username: String? // TODO: Create username entity

    public init(
        email: String,
        phone: String? = nil,
        username: String? = nil
    ) {
        self.username = username
        self.email = email
        self.phone = phone
    }
}
