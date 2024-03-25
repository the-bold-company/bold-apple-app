//
//  RecordTransactionRespose.swift
//
//
//  Created by Hien Tran on 24/03/2024.
//

import Codextended
import DomainEntities
import Foundation

struct RecordTransactionRespose: Decodable {
    let transactionId: String
    let portfolioId: String
    let type: String
    let amount: Decimal
    let currency: String
    let timestamp: Int
    let notes: String?
    let reason: String
    let tradeId: String?
    let fundId: String?

    init(from decoder: Decoder) throws {
        self.transactionId = try decoder.decode("transactionId")
        self.portfolioId = try decoder.decode("portfolioId")
        self.type = try decoder.decode("type")
        self.amount = try decoder.decode("amount")
        self.currency = try decoder.decode("currency")
        self.timestamp = try decoder.decode("timestamp")
        self.notes = try decoder.decodeIfPresent("notes")
        self.reason = try decoder.decode("reason")
        self.tradeId = try decoder.decodeIfPresent("tradeId")
        self.fundId = try decoder.decodeIfPresent("fundId")
    }
}

extension RecordTransactionRespose {
    func asInvestmentTransactionEntity() -> InvestmentTransactionEntity {
        return InvestmentTransactionEntity(
            id: ID(uuidString: transactionId),
            portfolioId: ID(uuidString: portfolioId),
            type: InvestmentTransactionType(rawValue: type)!,
            amount: Money(amount: amount),
            currency: Currency(currencyCode: currency),
            timestamp: timestamp,
            notes: notes,
            reason: reason,
            tradeId: tradeId != nil ? ID(uuidString: tradeId!) : nil,
            fundId: fundId != nil ? ID(uuidString: fundId!) : nil
        )
    }
}
