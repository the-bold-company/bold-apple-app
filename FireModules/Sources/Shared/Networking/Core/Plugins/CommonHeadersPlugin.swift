//
//  CommonHeadersPlugin.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import CasePaths
import Dependencies
import Foundation
import KeychainService
import Moya

struct CommonHeadersPlugin: PluginType {
    // swiftformat:disable unusedArguments
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        @Dependency(\.keychainService) var keychainService
        var newRequest = request

        if let accessToken = keychainService.getAccessToken()[case: \.success] {
            newRequest.headers.add(name: "Authorization", value: "Bearer \(accessToken)")
        }

        return newRequest
    }
    // swiftformat:enable unusedArguments
}
