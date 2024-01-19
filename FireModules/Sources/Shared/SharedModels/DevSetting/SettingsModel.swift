//
//  SettingsModel.swift
//
//
//  Created by Hien Tran on 19/01/2024.
//

import Combine

public class SettingsModel: ObservableObject {
    public var betaSettings: DevSettings = .init()

    public init() {}
}
