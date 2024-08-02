import CasePaths
import Codextended
import DomainUtilities
import Foundation

// public protocol AccountTemplate {
//    var name: String { get }
//    var type: AccountType { get }
//    var icon: String? { get }
//    var currencyId: String { get }
//    var cells: [AnyAccountCell] { get }
// }

// public struct AccountBalanceCell: AccountCellTemplate {
//    public let name = "BANK_ACCOUNT_CURRENT_BALANCE"
//    public let value: AccountCellValue
//    public let title = "Số tiền hiện có"
//
//    public init(value: Decimal) {
//        self.value = .number(value)
//    }
// }

// public typealias AccountEntityTemplate = AccountTemplate & HasId & HasUserId

// public struct AnyAccountEntity: AccountEntityTemplate, Decodable {
//    public let id: ID
//    public let name: String
//    public var type: AccountType
//    public let icon: String?
//    public let currencyId: String // TODO: convert to Currency
//    public let cells: [AnyAccountCell]
//
//    public init(from decoder: any Decoder) throws {
//        self.name = try decoder.decode("name")
//        self.type = try decoder.decode("type")
//        self.icon = try decoder.decodeIfPresent("icon")
//        self.currencyId = try decoder.decode("currencyId")
//        self.cells = try decoder.decode("cells")
//    }
// }

// public struct BankAccount: AccountEntityTemplate, Decodable {
//    public let id: ID
//    public let name: String
//    public var type: AccountType
//    public let icon: String?
//    public let currencyId: String // TODO: convert to Currency
//    public let balanceCell: AccountBalanceCell
//    public let cells: [AnyAccountCell]
//
//    public init(from decoder: any Decoder) throws {
//        self.name = try decoder.decode("name")
//        self.type = try decoder.decode("type")
//        self.icon = try decoder.decodeIfPresent("icon")
//        self.currencyId = try decoder.decode("currencyId")
//        self.cells = try decoder.decode("cells")
//    }
//
//    public init(
//        id: ID,
//        name: String,
//        type: AccountType,
//        icon: String?,
//        currencyId: String,
//        balanceCell: AccountBalanceCell
//    ) {
//        self.id = id
//        self.name = name
//        self.type = type
//        self.icon = icon
//        self.currencyId = currencyId
//        self.balanceCell = balanceCell
//        self.cells = [balanceCell.eraseToAnyAccountCell]
//    }
// }
