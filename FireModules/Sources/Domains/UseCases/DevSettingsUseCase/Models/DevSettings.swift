//
//  DevSettings.swift
//
//
//  Created by Hien Tran on 18/01/2024.
//

import AutomaticSettings
import Combine
import SwiftUI

public struct DevSettings: AutomaticSettings {
    public struct Credentials: AutomaticSettings {
        public var username: String = ""
        public var password: String = ""

        public init() {}
    }

    public struct Theme: AutomaticSettings {
        public enum AppColor: String, Codable, CaseIterable, CustomStringConvertible {
            case red
            case normal

            public var description: String { return rawValue }

            public var color: Color {
                switch self {
                case .normal:
                    return .black
                case .red:
                    return .red
                }
            }
        }

        public var color: AppColor = .normal

        public init() {}
    }

    public var credentials: Credentials = .init()
    public var theme: Theme = .init()

    public init(
        credentials: DevSettings.Credentials = .init(),
        theme: DevSettings.Theme = .init()
    ) {
        self.credentials = credentials
        self.theme = theme
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.credentials = try container.decode(Credentials.self, forKey: .credentials)
        self.theme = try container.decode(Theme.self, forKey: .theme)
    }

//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.credentials, forKey: .credentials)
//        try container.encode(self.theme, forKey: .theme)
//    }
}

public class DevSettingsExternalData: ObservableObject {
    public init() {}
}
