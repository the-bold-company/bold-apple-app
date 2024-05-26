import Foundation
import Networking

enum InvestmentAPI {
    case createPortfolio(name: String)
    case getPortfolioList
    case portfolioDetails(id: String)
    case recordTransaction(
        portfolioId: String,
        type: String,
        amount: Decimal,
        currency: String,
        notes: String?
    )
    case getTransactionHistory(portfolioId: String)
}

extension InvestmentAPI: BaseTargetType {
    var path: String {
        switch self {
        case .createPortfolio:
            return "/investment/create-porfolio"
        case .getPortfolioList:
            return "/investment/portfolio/list"
        case let .recordTransaction(portfolioId, _, _, _, _):
            return "/investment/portfolio/\(portfolioId)/record-transaction"
        case let .portfolioDetails(id):
            return "/investment/portfolio/\(id)"
        case let .getTransactionHistory(portfolioId):
            return "/investment/portfolio/\(portfolioId)/transaction-list"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createPortfolio, .recordTransaction:
            return .post
        case .getPortfolioList, .portfolioDetails, .getTransactionHistory:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .createPortfolio(name):
            return .requestParameters(
                parameters: ["portfolioName": name],
                encoding: JSONEncoding.default
            )
        case .getPortfolioList, .portfolioDetails, .getTransactionHistory:
            return .requestPlain
        case let .recordTransaction(_, type, amount, currency, notes):
            var parameters: [String: Any] = [
                "type": type,
                "amount": amount,
                "currency": currency,
            ]

            if let notes {
                parameters["notes"] = notes
            }
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        }
    }
}
