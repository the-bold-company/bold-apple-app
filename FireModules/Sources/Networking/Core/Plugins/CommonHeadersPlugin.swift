//
//  CommonHeadersPlugin.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import Foundation
import Moya

struct CommonHeadersPlugin: PluginType {
    // swiftformat:disable unusedArguments
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var newRequest = request

        // newRequest.headers.add(name: "authorization", value: "Bearer \(accessToken)")

        return newRequest
    }
    // swiftformat:enable unusedArguments
}
