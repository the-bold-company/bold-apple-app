//
//  TransactionEntity.swift
//
//
//  Created by Hien Tran on 28/01/2024.
//

import Foundation

public struct TransactionEntity: Equatable, Identifiable, Hashable {
    public let id: UUID // TODO: Create a new data structure for ID. Don't use UUID because it automatically capitalize the string
    public let timestamp: Int
    public let sourceFundId: UUID
    public let destinationFundId: UUID?
    public let amount: Decimal
    public let type: TransactionType
    public let userId: UUID
    public let currency: String
    public let description: String?

    public init(
        id: String,
        timestamp: Int,
        sourceFundId: String,
        destinationFundId: String?,
        amount: Decimal,
        type: String,
        userId: String,
        currency: String,
        description: String?
    ) {
        self.id = UUID(uuidString: id)! // swiftlint:disable:this force_unwrapping
        self.timestamp = timestamp
        self.sourceFundId = UUID(uuidString: sourceFundId)! // swiftlint:disable:this force_unwrapping
        self.destinationFundId = UUID(uuidString: destinationFundId ?? "")
        self.amount = amount
        self.type = TransactionType(rawValue: type)! // swiftlint:disable:this force_unwrapping
        self.userId = UUID(uuidString: userId)! // swiftlint:disable:this force_unwrapping
        self.currency = currency
        self.description = description
    }
}

public extension TransactionEntity {
    static func mock(id: UUID) -> Self {
        return Self(
            id: id.uuidString,
            timestamp: 0,
            sourceFundId: UUID().uuidString,
            destinationFundId: UUID().uuidString,
            amount: 100_000,
            type: "inout",
            userId: UUID().uuidString,
            currency: "VND",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        )
    }
}

public enum TransactionType: String {
    case `inout`
    case `in`
    case out
}
