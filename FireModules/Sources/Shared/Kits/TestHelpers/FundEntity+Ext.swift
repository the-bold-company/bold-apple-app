//
//  FundEntity+Ext.swift
//
//
//  Created by Hien Tran on 03/03/2024.
//

import DomainEntities
import Foundation

public extension FundEntity {
    static var fiatList1: [FundEntity] {
        [
            FundEntity(
                id: "c25d7db0-9944-42bd-9252-e4d240590ce2",
                balance: 100,
                name: "Eat out",
                currency: "USD",
                fundType: "fiat"
            ),
            FundEntity(
                id: "abd5eedf-dd1d-41fd-95dd-beb803c20006",
                balance: 10_000_000,
                name: "2nd Home",
                currency: "SGD",
                fundType: "fiat"
            ),
            FundEntity.payBills,
            FundEntity.freelance,
        ]
    }

    static let payBills = FundEntity(
        id: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
        balance: 0,
        name: "Pay bills",
        currency: "VND",
        fundType: "fiat"
    )

    static let freelance = FundEntity(
        id: "d8394718-9e23-4680-a30c-2a0b14efd695",
        balance: 10_000_000_000,
        name: "Freelance",
        currency: "VND",
        fundType: "fiat"
    )

    static let example1 = FundEntity(
        id: "78a07b88-e8e0-40a4-adfc-23ae19ef6c27",
        balance: 0,
        name: "Party",
        currency: "VND",
        fundType: "fiat"
    )

    func updating(
        balance: Decimal? = nil,
        name: String? = nil,
        description: String? = nil
    ) -> FundEntity {
        return FundEntity(
            uuid: id,
            balance: balance ?? self.balance,
            name: name ?? self.name,
            currency: currency,
            description: description ?? self.description,
            fundType: fundType.rawValue
        )
    }
}
