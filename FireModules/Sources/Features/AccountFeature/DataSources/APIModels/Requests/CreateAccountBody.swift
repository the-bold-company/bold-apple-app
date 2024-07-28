import Codextended
import Foundation

public struct CreateAccountBody: Encodable {
    let name: String
    let type: AccountType
    let icon: String?
    let currencyId: String
    let cells: [AnyAccountCell]

    public func encode(to encoder: any Encoder) throws {
        try encoder.encode(name, for: "name")
        try type.encode(to: encoder)
        try encoder.encode(currencyId, for: "currencyId")
        try encoder.encode(cells, for: "cells")
        try encoder.encodeIfPresent(icon, for: "icon")
    }
}

enum AccountType: String, Encodable {
    case credit = "CreditAccount"
    case bank = "BankAccount"

    func encode(to encoder: any Encoder) throws {
        try encoder.encode(rawValue, for: "type")
    }
}

protocol AccountCellType: Encodable {
    var name: String { get }
    var value: AccountCellValue { get }
    var title: String { get }
}

extension AccountCellType {
    func encode(to encoder: any Encoder) throws {
        try encoder.encode(name, for: "name")
        try encoder.encode(title, for: "title")
        try value.encode(to: encoder)
    }

    var eraseToAnyAccountCell: AnyAccountCell {
        .init(self)
    }
}

struct AnyAccountCell: Encodable {
    private let base: AccountCellType

    init(_ base: AccountCellType) {
        self.base = base
    }

    func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

enum AccountCellValue: Encodable {
    case boolean(Bool)
    case number(Decimal)
    case string(String)

    func encode(to encoder: any Encoder) throws {
        switch self {
        case let .boolean(bool):
            try encoder.encode("BooleanType", for: "valueType")
            try encoder.encode(bool, for: "value")
        case let .number(decimal):
            try encoder.encode("NumberType", for: "valueType")
            try encoder.encode(decimal, for: "value")
        case let .string(string):
            try encoder.encode("StringType", for: "valueType")
            try encoder.encode(string, for: "value")
        }
    }
}

struct AccountBalanceCell: AccountCellType {
    let name = "BANK_ACCOUNT_CURRENT_BALANCE"
    let value: AccountCellValue
    let title = "Số tiền hiện có"

    init(value: Decimal) {
        self.value = .number(value)
    }
}
