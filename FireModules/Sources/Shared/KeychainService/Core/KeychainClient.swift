import Foundation
import KeychainAccess
import KeychainServiceInterface

let KEYCHAIN_SERVICE_ID = Bundle.main.bundleIdentifier ?? "ai.mouka.app"
let KEYCHAIN_SERVICE_ERROR_DOMAIN = "\(KEYCHAIN_SERVICE_ID).error"

struct KeychainClient {
    private let keychain = Keychain(service: KEYCHAIN_SERVICE_ID)

    func set<V>(_ value: V, forKey key: KeychainKey) throws {
        if let valueAsString = value as? String {
            try keychain.set(valueAsString, key: key.keyedValue)
        } else if let valueAsData = value as? Data {
            try keychain.set(valueAsData, key: key.keyedValue)
        } else {
            throw NSError(
                domain: KEYCHAIN_SERVICE_ERROR_DOMAIN,
                code: -99998,
                userInfo: [NSLocalizedDescriptionKey: "Failed to set value for key \(key.keyedValue). The type of \(V.self) is not supported"]
            )
        }
    }

    func remove(forKey key: KeychainKey) throws {
        try keychain.remove(key.keyedValue)
    }

    func get<V>(_: V.Type, forKey key: KeychainKey) throws -> V {
        if V.self == String.self {
            let value = try keychain.getString(key.keyedValue)

            if let value = value as? V {
                return value
            } else {
                throw NSError(
                    domain: KEYCHAIN_SERVICE_ERROR_DOMAIN,
                    code: -99997,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to get value for key \(key.keyedValue). Value happens to be nil"]
                )
            }
        } else if V.self == Data.self {
            let value = try keychain.get(key.keyedValue)
            if let value = value as? V {
                return value
            } else {
                throw NSError(
                    domain: KEYCHAIN_SERVICE_ERROR_DOMAIN,
                    code: -99997,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to get value for key \(key.keyedValue). Value happens to be nil"]
                )
            }
        }

        throw NSError(
            domain: KEYCHAIN_SERVICE_ERROR_DOMAIN,
            code: -99998,
            userInfo: [NSLocalizedDescriptionKey: "Failed to get value for key \(key.keyedValue). The type of \(V.self) is not supported"]
        )
    }
}
