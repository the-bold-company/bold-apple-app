//
//  KeychainService.swift
//
//
//  Created by Hien Tran on 09/01/2024.
//

import DomainEntities
import Foundation
import KeychainServiceInterface

public struct KeychainService: KeychainServiceProtocol {
    public init() {}
    let keychain = KeychainClient()

    public func getCredentials() throws -> CredentialsEntity {
        guard let accessToken = keychain.get(type: String.self, forKey: .accessToken) else {
            throw KeychainError.failToGet([.accessToken]).asDomainError
        }

        guard let refreshToken = keychain.get(type: String.self, forKey: .refreshToken) else {
            throw KeychainError.failToGet([.refreshToken]).asDomainError
        }

        guard let idToken = keychain.get(type: String.self, forKey: .idToken) else {
            throw KeychainError.failToGet([.idToken]).asDomainError
        }

        return CredentialsEntity(accessToken: accessToken, refreshToken: refreshToken, idToken: idToken)
    }

    @discardableResult
    public func setCredentials(accessToken: String, refreshToken: String, idToken: String) throws -> CredentialsEntity {
        let accessTokenSaved = keychain.set(accessToken, forKey: .accessToken)
        let refreshTokenSaved = keychain.set(refreshToken, forKey: .refreshToken)
        let idTokenSaved = keychain.set(refreshToken, forKey: .idToken)

        switch (accessTokenSaved, refreshTokenSaved, idTokenSaved) {
        case (false, false, false):
            throw KeychainError.failToGet([.accessToken, .refreshToken, .idToken]).asDomainError
        case (false, false, true):
            throw KeychainError.failToGet([.accessToken, .refreshToken]).asDomainError
        case (false, true, true):
            throw KeychainError.failToGet([.accessToken]).asDomainError
        case (false, true, false):
            throw KeychainError.failToGet([.accessToken, .idToken]).asDomainError
        case (true, false, false):
            throw KeychainError.failToGet([.refreshToken, .idToken]).asDomainError
        case (true, false, true):
            throw KeychainError.failToGet([.refreshToken]).asDomainError
        case (true, true, false):
            throw KeychainError.failToGet([.idToken]).asDomainError
        case (true, true, true):
            return CredentialsEntity(accessToken: accessToken, refreshToken: refreshToken, idToken: idToken)
        }
    }

    public func getAccessToken() throws -> String {
        guard let accessToken = keychain.get(type: String.self, forKey: .accessToken) else {
            throw KeychainError.failToGet([.accessToken]).asDomainError
        }

        return accessToken
    }

    public func getRefreshToken() throws -> String {
        guard let refreshToken = keychain.get(type: String.self, forKey: .refreshToken) else {
            throw KeychainError.failToGet([.refreshToken]).asDomainError
        }
        return refreshToken
    }

    public func getIDToken() throws -> String {
        guard let idToken = keychain.get(type: String.self, forKey: .idToken) else {
            throw KeychainError.failToGet([.idToken]).asDomainError
        }
        return idToken
    }

    public func removeCredentials() throws {
        let accessTokenRemoved = keychain.remove(forKey: .accessToken)
        let refreshTokenRemoved = keychain.remove(forKey: .refreshToken)
        let idTokenRemoved = keychain.remove(forKey: .idToken)

        switch (accessTokenRemoved, refreshTokenRemoved, idTokenRemoved) {
        case (false, false, false):
            throw KeychainError.failToRemove([.accessToken, .refreshToken, .idToken]).asDomainError
        case (false, false, true):
            throw KeychainError.failToRemove([.accessToken, .refreshToken]).asDomainError
        case (false, true, true):
            throw KeychainError.failToRemove([.accessToken]).asDomainError
        case (false, true, false):
            throw KeychainError.failToRemove([.accessToken, .idToken]).asDomainError
        case (true, false, false):
            throw KeychainError.failToRemove([.refreshToken, .idToken]).asDomainError
        case (true, false, true):
            throw KeychainError.failToRemove([.refreshToken]).asDomainError
        case (true, true, false):
            throw KeychainError.failToRemove([.idToken]).asDomainError
        case (true, true, true):
            break
        }
    }
}

public enum KeychainError: LocalizedError {
    case failToGet([KeychainKey])
    case failToSet([KeychainKey])
    case failToRemove([KeychainKey])

    public var errorDescription: String? {
        switch self {
        case let .failToGet(keys):
            return "Failed to retrieve \(keys.map(\.name).joined(separator: ", ")) from keychain"
        case let .failToSet(keys):
            return "Failed to write \(keys.map(\.name).joined(separator: ", ")) to keychain"
        case let .failToRemove(keys):
            return "Failed to remove \(keys.map(\.name).joined(separator: ", ")) from keychain"
        }
    }

    public var failureReason: String? {
        switch self {
        case let .failToGet(keys):
            return "Failed to retrieve \(keys.map(\.name).joined(separator: ", ")) from keychain"
        case let .failToSet(keys):
            return "Failed to write \(keys.map(\.name).joined(separator: ", ")) to keychain"
        case let .failToRemove(keys):
            return "Failed to remove \(keys.map(\.name).joined(separator: ", ")) from keychain"
        }
    }

    public var asDomainError: DomainError {
        return DomainError(error: self)
    }
}
