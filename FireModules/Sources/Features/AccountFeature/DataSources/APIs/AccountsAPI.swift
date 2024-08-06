import Codextended
import Foundation
import Moya
import Networking

enum AccountsAPI {
    enum v1 {
        case createAccount(CreateAccountBody)
        case getAccountList
    }
}

extension AccountsAPI.v1: BaseTargetType {
    var serviceId: String? { "account-management" }

    var versionId: String? { "v1" }

    var path: String {
        switch self {
        case .createAccount, .getAccountList:
            return "accounts"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createAccount:
            return .post
        case .getAccountList:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .createAccount(body):
            return .requestJSONEncodable(body)
        case .getAccountList:
            return .requestPlain
        }
    }
}
