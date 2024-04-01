import Foundation
import Networking

enum MarketAPI {
    case convertCurrency(amount: Decimal, fromCurrency: String, toCurrency: String)
}

extension MarketAPI: BaseTargetType {
    var path: String {
        switch self {
        case let .convertCurrency:
            return "/stock/currency-conversion"
        }
    }

    var method: Moya.Method {
        switch self {
        case .convertCurrency: return .get
        }
    }

    var task: Task {
        switch self {
        case let .convertCurrency(amount, from, to):
            return .requestParameters(
                parameters: [
                    "symbol": "\(from)/\(to)",
                    "amount": amount,
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
}
