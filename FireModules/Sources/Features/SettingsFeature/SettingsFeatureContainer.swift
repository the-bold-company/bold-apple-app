//
//  SettingsFeatureContainer.swift
//
//
//  Created by Hien Tran on 29/02/2024.
//

import DevSettingsUseCase
import Factory

public final class SettingsFeatureContainer: SharedContainer {
    public static let shared = SettingsFeatureContainer()
    public let manager = ContainerManager()
}

public extension SettingsFeatureContainer {
    var devSettingsUseCase: Factory<DevSettingsUseCase?> { self { nil } }
    var devSettingsReducer: Factory<DevSettingsReducer?> { self { nil } }
}
