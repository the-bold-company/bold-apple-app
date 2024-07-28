import Codextended
import Foundation
import Moya
import Networking

enum AccountsAPI {
    enum v1 {
        case createAccount(CreateAccountBody)
    }
}

extension AccountsAPI.v1: BaseTargetType {
    var path: String {
        switch self {
        case .createAccount:
            return "account-management/v1/accounts"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createAccount:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case let .createAccount(body):
            return .requestJSONEncodable(body)
        }
    }
}
