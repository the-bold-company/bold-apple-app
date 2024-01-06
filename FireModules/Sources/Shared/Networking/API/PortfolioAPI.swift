//
//  PortfolioAPI.swift
//
//
//  Created by Hien Tran on 07/01/2024.
//

import Moya

enum PortfolioAPI {
    case networth
}

extension PortfolioAPI: BaseTargetType {
    var path: String {
        switch self {
        case .networth: return "/portfolio/networth"
        }
    }

    var method: Method {
        switch self {
        case .networth: return .get
        }
    }

    var task: Task {
        switch self {
        case .networth:
            return .requestPlain
        }
    }
}
