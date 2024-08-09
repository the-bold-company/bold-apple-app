import Codextended
import Foundation
import Moya
import Networking

enum TransactionsAPI {
    enum v1 {
        case createTransaction(
            type: TransactionType,
            amount: Decimal,
            accountId: String,
            date: TimeInterval,
            categoryId: String?,
            name: String?,
            note: String?
        )
    }
}

extension TransactionsAPI.v1: BaseTargetType {
    var serviceId: String? { "account-management" }

    var versionId: String? { "v1" }

    var path: String {
        switch self {
        case .createTransaction:
            return "transactions"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createTransaction:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case let .createTransaction(type, amount, accountId, date, categoryId, name, note):
            return .requestParameters(
                parameters: [
                    "type": type.rawValue,
                    "amount": amount,
                    "accountId": accountId,
                    "transferDate": "\(date)",
                    "categoryId": categoryId as Any,
                    "name": name as Any,
                    "notes": note as Any,
                ],
                encoding: JSONEncoding()
            )
        }
    }
}
