//
//  DevSettingsUseCase.swift
//
//
//  Created by Hien Tran on 20/01/2024.
//

import Codextended
import Combine
import ConcurrencyExtras
import Foundation

private let devSettingsFileName = "dev-settings"

public extension DevSettingsUseCase {
    static var devSettingsFilePath: URL {
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(devSettingsFileName)
            .appendingPathExtension("json")
    }

    static var live: DevSettingsUseCase {
        let initialDevSettingsData = (try? Data(contentsOf: devSettingsFilePath)) ?? Data()
        let initialDevSettings = (try? initialDevSettingsData.decoded(as: DevSettings.self)) ?? DevSettings()

        let devSettings = LockIsolated(initialDevSettings)
        let subject = PassthroughSubject<DevSettings, Never>()
        return DevSettingsUseCase(
            get: {
                devSettings.value
            },
            set: { newSettings in
                devSettings.withValue {
                    $0 = newSettings
                    subject.send(newSettings)
                    try? newSettings.encoded().write(to: devSettingsFilePath)
                }
            },
            stream: {
                subject.values.eraseToStream()
            }
        )
    }
}
