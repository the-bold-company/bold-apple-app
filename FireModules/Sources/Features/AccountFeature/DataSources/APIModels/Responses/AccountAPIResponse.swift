import Codextended
import Foundation

public struct AccountAPIResponse: BaseAccount, HasId, HasUserId, HasAccountStatus, HasAccountCellEntities, Decodable, Equatable, Identifiable {
    public typealias ID = Id

    public let id: Id
    public let name: String
    public let type: AccountType
    public let status: String
    public let icon: String?
    public let currencyId: String
    public let userId: Id
    public let cells: [AnyAccountCellEntity]

    public init(from decoder: any Decoder) throws {
        let idString: String = try decoder.decode("id")
        self.id = Id(idString)

        let userIdString: String = try decoder.decode("userId")
        self.userId = Id(userIdString)

        self.name = try decoder.decode("name")
        self.type = try decoder.decode("type")
        self.status = try decoder.decode("status")
        self.icon = try decoder.decodeIfPresent("icon")
        self.currencyId = try decoder.decode("currencyId")
        self.cells = try decoder.decode("cells")
    }
}

public protocol BaseAccount {
    var name: String { get }
    var type: AccountType { get }
    var icon: String? { get }
    var currencyId: String { get }
}

public protocol HasAccountCell {
    var cells: [AnyBaseAccountCell] { get }
}

public protocol HasAccountCellEntities {
    var cells: [AnyAccountCellEntity] { get }
}

public protocol HasIndex {
    var index: Int { get }
}

public protocol HasAccountStatus {
    var status: String { get }
}

public protocol BaseAccountCell: Encodable {
    var name: String { get }
    var value: AccountCellValue { get }
    var title: String { get }
}

public extension BaseAccountCell {
    func encode(to encoder: Encoder) throws {
        try encoder.encode(name, for: "name")
        try encoder.encode(title, for: "title")
        try value.encode(to: encoder)
    }
}

public extension BaseAccountCell {
    var eraseToAnyAccountCell: AnyBaseAccountCell {
        .init(self)
    }
}

public typealias AccountCellEntityTemplate = BaseAccountCell & HasAccountId & HasCreatedBy & HasId & HasIndex

public struct AccountBalanceCell: BaseAccountCell {
    public let name = "BANK_ACCOUNT_CURRENT_BALANCE"
    public let value: AccountCellValue
    public let title = "Số tiền hiện có"

    public init(value: Decimal) {
        self.value = .number(value)
    }
}

public struct AnyBaseAccountCell: BaseAccountCell, Codable {
    public let name: String
    public let value: AccountCellValue
    public let title: String

    public init(from decoder: any Decoder) throws {
        self.name = try decoder.decode("name")
        self.value = try AccountCellValue(from: decoder)
        self.title = try decoder.decode("title")
    }

    init(_ base: BaseAccountCell) {
        self.name = base.name
        self.value = base.value
        self.title = base.title
    }
}

public struct AnyAccountCellEntity: AccountCellEntityTemplate, Codable, Equatable {
    public var id: Id
    public let name: String
    public let value: AccountCellValue
    public let title: String
    public var createBy: Id
    public var accountId: Id
    public var index: Int

    public init(from decoder: any Decoder) throws {
        let idString: String = try decoder.decode("id")
        self.id = Id(idString)

        let createByIdString: String = try decoder.decode("createdBy")
        self.createBy = Id(createByIdString)

        let accountIdString: String = try decoder.decode("accountId")
        self.accountId = Id(accountIdString)

        self.name = try decoder.decode("name")
        self.value = try AccountCellValue(from: decoder)
        self.title = try decoder.decode("title")
        self.index = try decoder.decode("index")
    }
}
