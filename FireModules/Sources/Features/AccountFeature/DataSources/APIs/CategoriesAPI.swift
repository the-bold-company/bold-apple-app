import Codextended
import Foundation
import Moya
import Networking

enum CategoriesAPI {
    enum v1 {
        case getCategories(transferType: String)
        case createCategory(
            icon: String,
            name: String,
            transferType: String
        )
    }
}

extension CategoriesAPI.v1: BaseTargetType {
    var serviceId: String? { "account-management" }
    var versionId: String? { "v1" }

    var path: String {
        switch self {
        case .getCategories, .createCategory:
            return "categories"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getCategories:
            return .get
        case .createCategory:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case let .getCategories(transferType):
            return .requestParameters(
                parameters: ["type": transferType],
                encoding: URLEncoding.queryString
            )
        case let .createCategory(icon, name, transferType):
            return .requestParameters(
                parameters: [
                    "icon": icon,
                    "name": name,
                    "type": transferType,
                ],
                encoding: JSONEncoding.default
            )
        }
    }
}
