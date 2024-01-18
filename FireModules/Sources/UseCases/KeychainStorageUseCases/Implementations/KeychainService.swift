//
//  KeychainService.swift
//
//
//  Created by Hien Tran on 09/01/2024.
//

import Foundation

public struct KeychainService: KeychainServiceType {
    public init() {}
    let keychain = KeychainClient()

    public func getCredentials() -> Credentials? {
        guard let accessToken = keychain.get(type: String.self, forKey: .accessToken),
              let refreshToken = keychain.get(type: String.self, forKey: .refreshToken)
        else { return nil }

        return Credentials(accessToken: accessToken, refreshToken: refreshToken)
    }

    @discardableResult
    public func setCredentials(accessToken: String, refreshToken: String) -> Bool {
        return keychain.set(accessToken, forKey: .accessToken)
            && keychain.set(refreshToken, forKey: .refreshToken)
    }

    public func getAccessToken() -> String? {
        return getCredentials()?.accessToken
    }

    public func getRefreshToken() -> String? {
        return getCredentials()?.refreshToken
    }

    @discardableResult
    public func removeCredentials() -> Bool {
        return keychain.remove(forKey: .accessToken)
            && keychain.remove(forKey: .refreshToken)
    }
}
