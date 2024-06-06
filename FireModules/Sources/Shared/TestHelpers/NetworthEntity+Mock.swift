//
//  NetworthEntity+Mock.swift
//
//
//  Created by Hien Tran on 03/03/2024.
//

import DomainEntities

public extension NetworthEntity {
    static var vnd1000: NetworthEntity { NetworthEntity(networth: 1000, currency: "VND") }
    static var usd2000: NetworthEntity { NetworthEntity(networth: 2000, currency: "USD") }
    static let dumb = NetworthEntity(networth: 0, currency: "GBP")
}
