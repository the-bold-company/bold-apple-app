//
//  MoyaClient.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import Moya

final class MoyaClient<T: BaseTargetType>: MoyaProvider<T> {
    // TODO: COnfigure cache https://github.com/Moya/Moya/issues/976

    init() {
        super.init(
            plugins: [
                CommonHeadersPlugin(),

                // TODO: Add #if DEBUG here
                NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(
                    logOptions: [.formatRequestAscURL, .successResponseBody, .errorResponseBody]
                )),
            ]
        )
    }
}
