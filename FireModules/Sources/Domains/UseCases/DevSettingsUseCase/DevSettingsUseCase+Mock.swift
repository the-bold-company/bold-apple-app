//
//  DevSettingsUseCase+Mock.swift
//
//
//  Created by Hien Tran on 29/02/2024.
//

import Combine
import ConcurrencyExtras
import Foundation

public extension DevSettingsUseCase {
    static func mock(initialDevSettings: DevSettings = DevSettings()) -> DevSettingsUseCase {
        let devSettings = LockIsolated<DevSettings>(initialDevSettings)
        let subject = PassthroughSubject<DevSettings, Never>()
        return DevSettingsUseCase(
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
