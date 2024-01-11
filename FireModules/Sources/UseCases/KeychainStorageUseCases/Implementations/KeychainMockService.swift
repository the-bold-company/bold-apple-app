//
//  KeychainMockService.swift
//
//
//  Created by Hien Tran on 11/01/2024.
//

import Foundation

public struct KeychainMockService: KeychainServiceType {
    let accessToken: String
    let refreshToken: String

    public init(
        accessToken: String,
        refreshToken: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    public func getCredentials() -> Credentials? {
        return Credentials(accessToken: accessToken, refreshToken: refreshToken)
    }

    @discardableResult
    public func setCredentials(accessToken _: String, refreshToken _: String) -> Bool {
        return true
    }

    public func getAccessToken() -> String? {
        return getCredentials()?.accessToken
    }

    public func getRefreshToken() -> String? {
        return getCredentials()?.refreshToken
    }

    @discardableResult
    public func removeCredentials() -> Bool {
        return true
    }
}
