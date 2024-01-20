//
//  DevSettingsClient.swift
//
//
//  Created by Hien Tran on 20/01/2024.
//

import Codextended
import Combine
import ConcurrencyExtras
import Foundation
import SharedModels

public let devSettingsFileName = "dev-settings"

@dynamicMemberLookup
public struct DevSettingsClient {
    public var get: @Sendable () -> DevSettings
    public var set: @Sendable (DevSettings) async -> Void
    public var stream: @Sendable () -> AsyncStream<DevSettings>

    public subscript<Value>(dynamicMember keyPath: KeyPath<DevSettings, Value>) -> Value {
        return self.get()[keyPath: keyPath]
    }
}

extension DevSettingsClient {
    static var live: DevSettingsClient {
        // print("🌮 \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.absoluteString)")
        let userSettingsFileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(devSettingsFileName)
            .appendingPathExtension("json")
        let initialDevSettingsData = (try? Data(contentsOf: userSettingsFileURL)) ?? Data()
        let initialDevSettings = (try? initialDevSettingsData.decoded(as: DevSettings.self)) ?? DevSettings()

        let devSettings = LockIsolated(initialDevSettings)
        let subject = PassthroughSubject<DevSettings, Never>()
        return DevSettingsClient(
            get: {
                devSettings.value
            },
            set: { newSettings in
                devSettings.withValue {
                    $0 = newSettings
                    subject.send(newSettings)
                    try? newSettings.encoded().write(to: userSettingsFileURL)
                }
            },
            stream: {
                subject.values.eraseToStream()
            }
        )
    }

    static func mock(initialDevSettings: DevSettings = DevSettings()) -> Self {
        let devSettings = LockIsolated<DevSettings>(initialDevSettings)
        let subject = PassthroughSubject<DevSettings, Never>()
        return DevSettingsClient(
            get: { devSettings.value },
            set: { newValue in
                devSettings.withValue {
                    $0 = newValue
                    subject.send(newValue)
                }
            },
            stream: {
                subject.values.eraseToStream()
            }
        )
    }
}
