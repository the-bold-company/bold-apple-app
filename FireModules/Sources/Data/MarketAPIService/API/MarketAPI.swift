import Foundation
import Networking

enum MarketAPI {
    case convertCurrency(amount: Decimal, fromCurrency: String, toCurrency: String)
    case searchSymbol(String)
}

extension MarketAPI: BaseTargetType {
    var path: String {
        switch self {
        case .convertCurrency:
            return "/stock/currency-conversion"
        case .searchSymbol:
            return "/stock/symbol-search"
        }
    }

    var method: Moya.Method {
        switch self {
        case .convertCurrency, .searchSymbol:
            return .get
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
        case let .searchSymbol(searchText):
            return .requestParameters(
                parameters: ["symbol": searchText],
                encoding: URLEncoding.queryString
            )
        }
    }
}
