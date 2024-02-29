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

        return CredentialsEntity(accessToken: accessToken, refreshToken: refreshToken)
    }

    @discardableResult
    public func setCredentials(accessToken: String, refreshToken: String) throws -> CredentialsEntity {
        let accessTokenSaved = keychain.set(accessToken, forKey: .accessToken)
        let refreshTokenSaved = keychain.set(refreshToken, forKey: .refreshToken)

        switch (accessTokenSaved, refreshTokenSaved) {
        case (false, false):
            throw KeychainError.failToGet([.accessToken, .refreshToken]).asDomainError
        case (false, true):
            throw KeychainError.failToGet([.accessToken]).asDomainError
        case (true, false):
            throw KeychainError.failToGet([.refreshToken]).asDomainError
        case (true, true):
            return CredentialsEntity(accessToken: accessToken, refreshToken: refreshToken)
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

    public func removeCredentials() throws {
        let accessTokenRemoved = keychain.remove(forKey: .accessToken)
        let refreshTokenRemoved = keychain.remove(forKey: .refreshToken)

        switch (accessTokenRemoved, refreshTokenRemoved) {
        case (false, false):
            throw KeychainError.failToRemove([.accessToken, .refreshToken]).asDomainError
        case (false, true):
            throw KeychainError.failToRemove([.accessToken]).asDomainError
        case (true, false):
            throw KeychainError.failToRemove([.refreshToken]).asDomainError
        default:
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
