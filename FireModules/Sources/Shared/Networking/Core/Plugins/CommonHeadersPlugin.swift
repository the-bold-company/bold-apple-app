//
//  CommonHeadersPlugin.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import Foundation
import KeychainService // TODO: Remove this to avoid cycle dependency. Shared layer should't depend on Data layer. Use directly from `SwiftKeychainWrapper` or `KeychainServiceInterface` instead
import Moya

struct CommonHeadersPlugin: PluginType {
    let keychainService = KeychainService()
    // swiftformat:disable unusedArguments
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var newRequest = request

        if let accessToken = try? keychainService.getAccessToken() {
            newRequest.headers.add(name: "authorization", value: accessToken)
        }

        return newRequest
    }
    // swiftformat:enable unusedArguments
}
