//
//  KeychainClient.swift
//
//
//  Created by Hien Tran on 09/01/2024.
//

import Foundation
import SwiftKeychainWrapper

struct KeychainClient {
    private let keychain: KeychainWrapper = .standard

    @discardableResult
    func set<V>(_ value: V, forKey key: KeychainKey) -> Bool {
        if let valueAsInt = value as? Int {
            return keychain.set(valueAsInt, forKey: key.keyedValue)
        } else if let valueAsFloat = value as? Float {
            return keychain.set(valueAsFloat, forKey: key.keyedValue)
        } else if let valueAsDouble = value as? Double {
            return keychain.set(valueAsDouble, forKey: key.keyedValue)
        } else if let valueAsBool = value as? Bool {
            return keychain.set(valueAsBool, forKey: key.keyedValue)
        } else if let valueAsString = value as? String {
            return keychain.set(valueAsString, forKey: key.keyedValue)
        } else if let valueAsData = value as? Data {
            return keychain.set(valueAsData, forKey: key.keyedValue)
        } else {
            assertionFailure("The type of \(V.self) is not supported")
            return false
        }
    }

    @discardableResult
    func remove(forKey key: KeychainKey) -> Bool {
        return keychain.removeObject(forKey: key.keyedValue)
    }

    func get<V>(type _: V.Type, forKey key: KeychainKey) -> V? {
        if V.self == Int.self {
            return keychain.integer(forKey: key.keyedValue) as? V
        } else if V.self == Float.self {
            return keychain.float(forKey: key.keyedValue) as? V
        } else if V.self == Double.self {
            return keychain.double(forKey: key.keyedValue) as? V
        } else if V.self == Bool.self {
            return keychain.bool(forKey: key.keyedValue) as? V
        } else if V.self == String.self {
            return keychain.string(forKey: key.keyedValue) as? V
        } else if V.self == Data.self {
            return keychain.data(forKey: key.keyedValue) as? V
        } else {
            assertionFailure("The type of \(V.self) is not supported")
            return nil
        }
    }
}
