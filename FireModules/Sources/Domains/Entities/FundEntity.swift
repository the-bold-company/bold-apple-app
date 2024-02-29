//
//  FundEntity.swift
//
//
//  Created by Hien Tran on 24/01/2024.
//

import Foundation

public enum FundType: String, Decodable {
    case fiat
}

public struct FundEntity: Equatable, Identifiable, Hashable {
    /// Note: Do not use `id.uuidString` when sending request to server, use `serverCompartibleUUID` instead
    /// This UUID is auto-lowercased when parsing data from server. Server is compartible with the lowercased id.
    public let id: UUID
    public let balance: Decimal
    public let fundType: FundType
    public let name: String
    public let currency: String
    public let description: String?

    public init(
        id: String,
        balance: Decimal,
        name: String,
        currency: String,
        description: String? = nil,
        fundType: String
    ) {
        self.id = UUID(uuidString: id) ?? UUID()
        self.balance = balance
        self.name = name
        self.currency = currency
        self.description = description
        self.fundType = FundType(rawValue: fundType)! // TODO: Validate this
    }

    public init(
        uuid: UUID,
        balance: Decimal,
        name: String,
        currency: String,
        description: String? = nil,
        fundType: String
    ) {
        self.id = uuid
        self.balance = balance
        self.name = name
        self.currency = currency
        self.description = description
        self.fundType = FundType(rawValue: fundType)! // TODO: Validate this
    }
}

public extension UUID {
    /// Use thie roperty when sending request to server. Do not use `id.uuidString` because this value is uppercased automatically by Swift type `UUID`
    var serverCompartibleUUID: String {
        return uuidString.lowercased()
    }
}
