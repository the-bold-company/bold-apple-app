import Codextended
import Foundation

// TODO: Rename to CreateAccountRequestBody
public struct CreateAccountBody: Encodable {
    public let name: String
    public let type: AccountType
    public let icon: String?
    public let currencyId: String
    public let cells: [Cell]

    public struct Cell: Encodable {
        public let name: String
        public let value: AccountCellValue
        public let title: String

        public func encode(to encoder: Encoder) throws {
            try encoder.encode(name, for: "name")
            try encoder.encode(title, for: "title")
            try value.encode(to: encoder)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        try encoder.encode(name, for: "name")
        try encoder.encode(type, for: "type")
        try encoder.encode(currencyId, for: "currencyId")
        try encoder.encode(cells, for: "cells")
        try encoder.encodeIfPresent(icon, for: "icon")
    }
}

public extension CreateAccountBody.Cell {
    init(_ cell: BankAccountBalanceCell) {
        self.name = cell.name
        self.value = .number(cell.value)
        self.title = cell.title
    }

    init(_ cell: CreditAccountLimitCell) {
        self.name = cell.name
        self.value = .number(cell.value)
        self.title = cell.title
    }

    init(_ cell: CreditAccountBalanceCell) {
        self.name = cell.name
        self.value = .number(cell.value)
        self.title = cell.title
    }

    init(_ cell: CreditAccountStatementClosingDateCell) {
        self.name = cell.name
        self.value = .number(Decimal(cell.value))
        self.title = cell.title
    }

    init(_ cell: CreditAccountPaymentDueDateCell) {
        self.name = cell.name
        self.value = .number(Decimal(cell.value))
        self.title = cell.title
    }
}
