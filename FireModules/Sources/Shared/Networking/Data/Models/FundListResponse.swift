//
//  FundListResponse.swift
//
//
//  Created by Hien Tran on 10/01/2024.
//

import Codextended

public struct FundListResponse: Decodable, Equatable {
    public let funds: [CreateFundResponse]

    public init(from decoder: Decoder) throws {
        self.funds = try decoder.decode("funds")
    }
}
