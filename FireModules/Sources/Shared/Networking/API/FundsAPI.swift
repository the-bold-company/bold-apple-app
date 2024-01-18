//
//  FundsAPI.swift
//
//
//  Created by Hien Tran on 10/01/2024.
//

import Foundation
import Moya

public enum FundType: String, Decodable {
    case fiat
}

enum FundsAPI {
    case createFund(
        name: String,
        balance: Decimal,
        fundType: FundType,
        currency: String,
        description: String?
    )
    case listFunds
    case fundDetail(id: String)
    case deleteFund(id: String)
}

extension FundsAPI: BaseTargetType {
    var path: String {
        switch self {
        case .createFund:
            return "/funds/create"
        case .listFunds:
            return "/funds/list"
        case let .fundDetail(id):
            return "/funds/\(id)"
        case let .deleteFund(id):
            return "/funds/\(id)/delete"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createFund:
            return .post
        case .listFunds, .fundDetail:
            return .get
        case .deleteFund:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case let .createFund(name, balance, fundType, currency, description):
            return .requestParameters(
                parameters: [
                    "fundName": name,
                    "balance": "\(balance)",
                    "fundType": fundType.rawValue,
                    "description": description as Any,
                    "currency": currency,
                ],
                encoding: JSONEncoding.default
            )
        case .listFunds, .fundDetail, .deleteFund:
            return .requestPlain
        }
    }
}
