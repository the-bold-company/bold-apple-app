import Networking

enum InvestmentAPI {
    case createPortfolio(name: String)
    case getPortfolioList
}

extension InvestmentAPI: BaseTargetType {
    var path: String {
        switch self {
        case .createPortfolio:
            return "/investment/create-porfolio"
        case .getPortfolioList:
            return "/investment/portfolio/list"
        }
    }

    var method: Method {
        switch self {
        case .createPortfolio:
            return .post
        case .getPortfolioList:
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
        case .getPortfolioList:
            return .requestPlain
        }
    }
}
