//
//  TransactionsAPI.swift
//
//
//  Created by Hien Tran on 28/01/2024.
//

import Foundation
import Networking

enum TransactionsAPI {
    case record(
        sourceFundId: String,
        amount: Decimal,
        destinationFundId: String?,
        description: String?,
        type: String
    )
    case transactionList
}

extension TransactionsAPI: BaseTargetType {
    var serviceId: String? { nil }

    var versionId: String? { nil }

    var path: String {
        switch self {
        case .record:
            return "/transactions/record"
        case .transactionList:
            return "/transactions/list"
        }
    }

    var method: Moya.Method {
        switch self {
        case .record:
            return .post
        case .transactionList:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .record(sourceFundId, amount, destinationFundId, description, type):
            return .requestParameters(
                parameters: [
                    "sourceFundId": sourceFundId,
                    "amount": "\(amount)",
                    "destinationFundId": destinationFundId as Any,
                    "description": description as Any,
                    "type": type,
                ],
                encoding: JSONEncoding.default
            )
        case .transactionList:
            return .requestPlain
        }
    }
}
