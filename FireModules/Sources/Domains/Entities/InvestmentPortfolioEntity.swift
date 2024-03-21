//
//  InvestmentPortfolioEntity.swift
//
//
//  Created by Hien Tran on 18/03/2024.
//

import Foundation

public struct InvestmentPortfolioEntity: Equatable, Identifiable {
    public let id: ID
    public let totalInvestment: Money
    public let totalValue: Money
    public let name: String
    public let timestamp: Int
    public let description: String?
    public let lastModified: Int
//    public let balances: [String: Decimal]

    public init(
        id: ID,
        totalInvestment: Money = .zero,
        totalValue: Money = .zero,
        name: String,
        timestamp: Int,
        description: String? = nil,
        lastModified: Int
    ) {
        self.id = id
        self.totalInvestment = totalInvestment
        self.totalValue = totalValue
        self.name = name
        self.timestamp = timestamp
        self.description = description
        self.lastModified = lastModified
    }
}
