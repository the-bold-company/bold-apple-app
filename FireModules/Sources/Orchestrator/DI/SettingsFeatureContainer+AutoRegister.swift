//
//  SettingsFeatureContainer+AutoRegister.swift
//
//
//  Created by Hien Tran on 29/02/2024.
//

import SettingsFeature

extension SettingsFeatureContainer: AutoRegistering {
    public func autoRegister() {
        devSettingsUseCase.register { resolve(\.devSettingsUseCase) }
        devSettingsReducer.register { DevSettingsReducer(devSettingsUseCase: self.devSettingsUseCase.resolve()!) }
    }
}
