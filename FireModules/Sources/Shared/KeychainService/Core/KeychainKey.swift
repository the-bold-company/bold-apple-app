//
//  KeychainKey.swift
//
//
//  Created by Hien Tran on 09/01/2024.
//

private let prefix = "[mouka]"

public enum KeychainKey: String {
    case accessToken
    case refreshToken
    case idToken

    var keyedValue: String {
        return "\(prefix)\(rawValue)"
    }

    var name: String {
        switch self {
        case .accessToken:
            return "AccessToken"
        case .refreshToken:
            return "RefreshToken"
        case .idToken:
            return "IdToken"
        }
    }
}
