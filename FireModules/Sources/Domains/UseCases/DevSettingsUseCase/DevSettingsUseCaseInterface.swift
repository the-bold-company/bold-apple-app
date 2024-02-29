//
//  DevSettingsUseCaseInterface.swift
//
//
//  Created by Hien Tran on 29/02/2024.
//

import Foundation

@dynamicMemberLookup
public struct DevSettingsUseCase {
    public var get: @Sendable () -> DevSettings
    public var set: @Sendable (DevSettings) async -> Void
    public var stream: @Sendable () -> AsyncStream<DevSettings>

    public subscript<Value>(dynamicMember keyPath: KeyPath<DevSettings, Value>) -> Value {
        return self.get()[keyPath: keyPath]
    }
}
