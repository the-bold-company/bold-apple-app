import Codextended
import Foundation

// TODO: Rename to CreateAccountRequestBody
public struct CreateAccountBody: BaseAccount, HasAccountCell, Encodable {
    public let name: String
    public let type: AccountType
    public let icon: String?
    public let currencyId: String
    public let cells: [AnyBaseAccountCell]

    public func encode(to encoder: any Encoder) throws {
        try encoder.encode(name, for: "name")
        try encoder.encode(type, for: "type")
        try encoder.encode(currencyId, for: "currencyId")
        try encoder.encode(cells, for: "cells")
        try encoder.encodeIfPresent(icon, for: "icon")
    }
}
