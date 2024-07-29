//
//  KeychainService+live.swift
//
//
//  Created by Hien Tran on 09/01/2024.
//

import Dependencies
import DomainEntities
import Foundation
import KeychainAccess
import KeychainServiceInterface

public extension KeychainService {
    static func live() -> Self {
        let keychain = KeychainClient()

        @Sendable func errorCatcher<V>(
            perform: () throws -> V
        ) -> Result<V, KeychainError> {
            do {
                let output = try perform()
                return .success(output)
            } catch let status as Status {
                return .failure(.keychainError(status: status.rawValue, errorUserInfo: status.errorUserInfo))
            } catch {
                return .failure(.unknown(error))
            }
        }

        return Self(
            setCredentials: { accessToken, refreshToken, idToken in
                let accessTokenKey = KeychainKey.accessToken
                let refreshTokenKey = KeychainKey.refreshToken
                let idTokenKey = KeychainKey.idToken

                return errorCatcher {
                    try keychain.set(accessToken, forKey: accessTokenKey)
                    try keychain.set(refreshToken, forKey: refreshTokenKey)
                    try keychain.set(refreshToken, forKey: idTokenKey)

                    return CredentialsEntity(
                        accessToken: accessToken,
                        refreshToken: refreshToken,
                        idToken: idToken
                    )
                }
            },
            getAccessToken: {
                errorCatcher { try keychain.get(String.self, forKey: .accessToken) }
            },
            getRefreshToken: {
                errorCatcher { try keychain.get(String.self, forKey: .refreshToken) }
            },
            getIDToken: {
                errorCatcher { try keychain.get(String.self, forKey: .idToken) }
            },
            removeCredentials: {
                let accessTokenKey = KeychainKey.accessToken
                let refreshTokenKey = KeychainKey.refreshToken
                let idTokenKey = KeychainKey.idToken

                return errorCatcher {
                    try keychain.remove(forKey: accessTokenKey)
                    try keychain.remove(forKey: refreshTokenKey)
                    try keychain.remove(forKey: idTokenKey)
                    return ()
                }
            },
            getCredentials: {
                errorCatcher {
                    let accessToken = try keychain.get(String.self, forKey: .accessToken)
                    let refreshToken = try keychain.get(String.self, forKey: .refreshToken)
                    let idToken = try keychain.get(String.self, forKey: .idToken)

                    return CredentialsEntity(accessToken: accessToken, refreshToken: refreshToken, idToken: idToken)
                }
            }
        )
    }
}

extension KeychainServiceKey: DependencyKey {
    public static let liveValue = KeychainService.live()
}
