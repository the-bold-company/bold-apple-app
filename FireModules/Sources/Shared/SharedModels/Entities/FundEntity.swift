//
//  FundEntity.swift
//
//
//  Created by Hien Tran on 24/01/2024.
//

import Foundation

public struct FundEntity: Equatable, Identifiable, Hashable {
    public let id: UUID
    public let balance: Decimal
//    public let fundType: FundType
    public let name: String
    public let currency: String
    public let description: String?

    public init(
        id: String,
        balance: Decimal,
        name: String,
        currency: String,
        description: String?
    ) {
        self.id = UUID(uuidString: id) ?? UUID()
        self.balance = balance
        self.name = name
        self.currency = currency
        self.description = description
    }

    public init(
        uuid: UUID,
        balance: Decimal,
        name: String,
        currency: String,
        description: String?
    ) {
        self.id = uuid
        self.balance = balance
        self.name = name
        self.currency = currency
        self.description = description
    }
}
