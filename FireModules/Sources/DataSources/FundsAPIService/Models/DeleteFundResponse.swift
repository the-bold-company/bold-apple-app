//
//  DeleteFundResponse.swift
//
//
//  Created by Hien Tran on 18/01/2024.
//

import Codextended
import Foundation

public struct DeleteFundResponse: Decodable, Equatable, Identifiable {
    public let id: String

    public init(from decoder: Decoder) throws {
        self.id = try decoder.decode("fundId")
    }
}
