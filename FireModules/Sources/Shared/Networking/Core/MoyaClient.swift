import Foundation
import Moya

public final class MoyaClient<T: BaseTargetType>: MoyaProvider<T> {
    // TODO: COnfigure cache https://github.com/Moya/Moya/issues/976

    public init() {
        super.init(
            endpointClosure: { target in
                var url = target.baseURL
                if let serviceId = target.serviceId {
                    url.append(path: serviceId)
                }

                if let versionId = target.versionId {
                    url.append(path: versionId)
                }

                url.append(path: target.path)

                return Endpoint(
                    url: url.absoluteString,
                    sampleResponseClosure: { fatalError("We're not using this") },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            plugins: [
                CommonHeadersPlugin(),

                // TODO: Add #if DEBUG here
                // NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(
                //    logOptions: [.formatRequestAscURL, .successResponseBody, .errorResponseBody]
                // )),
            ]
        )
    }
}
