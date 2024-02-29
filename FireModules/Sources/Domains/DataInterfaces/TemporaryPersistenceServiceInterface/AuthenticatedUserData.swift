//
//  AuthenticatedUserData.swift
//
//
//  Created by Hien Tran on 29/02/2024.
//

import DomainEntities

public actor AuthenticatedUserData {
    public var loadedFunds: [FundEntity]

    public init(loadedFunds: [FundEntity]) {
        self.loadedFunds = loadedFunds
    }

    public func setLoadedFunds(funds: [FundEntity]) {
        loadedFunds = funds
    }

    public func cleanUp() {
        loadedFunds = []
    }
}
