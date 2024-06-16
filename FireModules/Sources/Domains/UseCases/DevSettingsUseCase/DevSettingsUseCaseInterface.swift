//
//  DevSettingsUseCaseInterface.swift
//
//
//  Created by Hien Tran on 29/02/2024.
//

import Dependencies
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

public extension DependencyValues {
    var devSettingsUseCase: DevSettingsUseCase {
        get { self[DevSettingsUseCaseKey.self] }
        set { self[DevSettingsUseCaseKey.self] = newValue }
    }
}

public extension DevSettingsUseCase {
    static let noop = Self(
        get: { DevSettings() },
        set: { _ in },
        stream: { fatalError() }
    )
}

public enum DevSettingsUseCaseKey: DependencyKey {
    public static let liveValue = DevSettingsUseCase.live

    #if DEBUG
        public static let testValue = DevSettingsUseCase(
            get: unimplemented("\(Self.self).get"),
            set: unimplemented("\(Self.self).set"),
            stream: unimplemented("\(Self.self).stream")
        )
        public static let previewValue = DevSettingsUseCase.noop
    #endif
}
