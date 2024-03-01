//
//  Mocks.swift
//
//
//  Created by Hien Tran on 11/01/2024.
//

import DomainEntities
import Foundation

extension FundEntity {
    static var mockList: [FundEntity] {
        return [
            FundEntity(
                id: "2f46ef50-c52e-4d26-8b40-ec6e37e7329d",
                balance: 300_000_000,
                name: "Fund placeholder for skeleton loading",
                currency: "VND",
                fundType: "fiat"
            ),
            FundEntity(
                id: "2fa5b5f2-6f99-47bf-b4f4-d9d0e34c28b9",
                balance: 300_000_000,
                name: "Fund placeholder for skeleton loading",
                currency: "VND",
                fundType: "fiat"
            ),
            FundEntity(
                id: "cb71f26a-d8ec-49cd-96db-6a1b45148007",
                balance: 300_000_000,
                name: "Fund placeholder for skeleton loading",
                currency: "VND",
                fundType: "fiat"
            ),
        ]
    }
}
