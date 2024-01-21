//
//  DependencyRegistration.swift
//
//
//  Created by Hien Tran on 20/01/2024.
//

import Dependencies

extension DevSettingsClient: DependencyKey {
    public static var liveValue = DevSettingsClient.live
    public static var testValue = DevSettingsClient.mock()
}

public extension DependencyValues {
    var devSettings: DevSettingsClient {
        get { self[DevSettingsClient.self] }
        set { self[DevSettingsClient.self] = newValue }
    }
}
