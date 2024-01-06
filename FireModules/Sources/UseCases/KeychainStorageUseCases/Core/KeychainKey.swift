//
//  KeychainKey.swift
//
//
//  Created by Hien Tran on 09/01/2024.
//

private let prefix = "[FIRE]"

public enum KeychainKey: String {
    case accessToken
    case refreshToken

    var keyedValue: String {
        return "\(prefix)\(rawValue)"
    }
}
