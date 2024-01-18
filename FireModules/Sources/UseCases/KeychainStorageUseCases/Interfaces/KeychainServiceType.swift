//
//  KeychainServiceType.swift
//
//
//  Created by Hien Tran on 09/01/2024.
//

import Foundation
import SwiftKeychainWrapper

public protocol KeychainServiceType {
    func getCredentials() -> Credentials?

    @discardableResult
    func setCredentials(accessToken: String, refreshToken: String) -> Bool

    @discardableResult
    func removeCredentials() -> Bool

    func getAccessToken() -> String?
    func getRefreshToken() -> String?
}
