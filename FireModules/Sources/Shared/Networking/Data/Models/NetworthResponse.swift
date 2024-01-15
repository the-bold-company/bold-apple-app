//
//  NetworthResponse.swift
//
//
//  Created by Hien Tran on 07/01/2024.
//

import Codextended
import Foundation

public struct NetworthResponse: Decodable, Equatable {
    public let networth: Decimal
    public let currency: String

    public init(from decoder: Decoder) throws {
        self.networth = try decoder.decode("networth")
        self.currency = try decoder.decode("currency")
    }
}
