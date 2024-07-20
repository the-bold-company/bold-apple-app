//
//  KeychainStorageServiceProtocol.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

import DomainEntities

public protocol KeychainServiceProtocol {
    @discardableResult
    func setCredentials(accessToken: String, refreshToken: String, idToken: String) throws -> CredentialsEntity

    func getAccessToken() throws -> String

    func getRefreshToken() throws -> String

    func getIDToken() throws -> String

    func removeCredentials() throws

    func getCredentials() throws -> CredentialsEntity
}
