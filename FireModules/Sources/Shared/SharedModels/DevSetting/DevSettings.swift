//
//  DevSettings.swift
//
//
//  Created by Hien Tran on 18/01/2024.
//

import AutomaticSettings
import Combine

public struct DevSettings: AutomaticSettings {
    public struct Credentials: AutomaticSettings {
        public var username: String = "hien.tran@fire.com"
        public var password: String = "Qwerty@123"

        public init() {}
    }

    public var credentials: Credentials = .init()

    public init() {}
}

public class DevSettingsExternalData: ObservableObject {
    public init() {}
}
