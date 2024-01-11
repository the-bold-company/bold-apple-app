//
//  Mocks.swift
//
//
//  Created by Hien Tran on 11/01/2024.
//

import Foundation
import Networking

extension CreateFundResponse {
    private static let mocks: [[String: Any]] = [
        [
            "fundId": "2f46ef50-c52e-4d26-8b40-ec6e37e7329d",
            "creatorId": "someID",
            "balance": 300_000_000,
            "fundType": "fiat",
            "name": "Fund placeholder for skeleton loading",
            "currency": "VND",
        ],
        [
            "fundId": "2fa5b5f2-6f99-47bf-b4f4-d9d0e34c28b9",
            "creatorId": "someID",
            "balance": 300_000_000,
            "fundType": "fiat",
            "name": "Fund placeholder for skeleton loading",
            "currency": "USD",
        ],
        [
            "fundId": "cb71f26a-d8ec-49cd-96db-6a1b45148007",
            "creatorId": "someID",
            "balance": 300_000_000,
            "fundType": "fiat",
            "name": "Fund placeholder for skeleton loading",
            "currency": "VND",
        ],
    ]

    static var mockList: [CreateFundResponse] {
        return mocks.map { dic in
            let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: []) // swiftlint:disable:this force_try
            return try! JSONDecoder().decode(CreateFundResponse.self, from: jsonData) // swiftlint:disable:this force_try
        }
    }
}
