//
//  NetworthEntity.swift
//
//
//  Created by Hien Tran on 28/02/2024.
//

import Foundation

public struct NetworthEntity: Equatable {
    public let networth: Decimal
    public let currency: String

    public init(networth: Decimal, currency: String) {
        self.networth = networth
        self.currency = currency
    }
}
