import DomainEntities
import Foundation

public protocol BaseAccount {
    var id: Id { get }
    var name: DefaultLengthConstrainedString { get }
    var status: String { get }
    var type: AccountType { get }
    var icon: String? { get }
    var balance: Money { get }
}

public struct AnyAccount: BaseAccount, Equatable, Identifiable {
    public typealias ID = Id

    let base: BaseAccount

    public var id: Id { base.id }
    public var name: DefaultLengthConstrainedString { base.name }
    public var type: AccountType { base.type }
    public var status: String { base.status }
    public var icon: String? { base.icon }
    public var balance: Money { base.balance }

    public init(_ base: BaseAccount) {
        self.base = base
    }

    public static func == (lhs: AnyAccount, rhs: AnyAccount) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.type == rhs.type
            && lhs.status == rhs.status
            && lhs.icon == rhs.icon
            && lhs.balance == rhs.balance
    }
}

public struct CreditAccount: BaseAccount, Equatable, Identifiable {
    public typealias ID = Id

    public let id: Id
    public private(set) var name: DefaultLengthConstrainedString
    public let type: AccountType
    public let status: String
    public private(set) var icon: String?
    public let userId: Id
    public private(set) var balance: Money
    public private(set) var limit: Money?
    @Clamping(range: 1 ... 31) private var paymentDueDate: Int = 1
    @Clamping(range: 1 ... 31) private var statementDate: Int = 1

    public init(
        id: Id,
        name: DefaultLengthConstrainedString,
        type: AccountType,
        status: String,
        icon: String? = nil,
        userId: Id,
        balance: Money,
        limit: Money? = nil,
        paymentDueDate: Int,
        statementDate: Int
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.status = status
        self.icon = icon
        self.userId = userId
        self.balance = balance
        self.limit = limit
        self.paymentDueDate = paymentDueDate
        self.statementDate = statementDate
    }

    public mutating func updateName(_ newName: String) {
        name.update(newName)
    }

    public mutating func updateName(_ newName: DefaultLengthConstrainedString) {
        name = newName
    }

    public mutating func updateIcon(_ newIcon: String?) {
        icon = newIcon
    }

    public mutating func updateBalance(_ newBalance: Decimal) {
        balance.updateAmount(newBalance)
    }

    public mutating func updateBalance(_ newBalance: Money) {
        balance = newBalance
    }

    public mutating func updateLimit(_ newLimit: Decimal) {
        if limit != nil {
            limit!.updateAmount(newLimit)
        } else {
            limit = Money(newLimit, currency: balance.currency)
        }
    }

    public mutating func updateLimit(_ newLimit: Money) {
        limit = newLimit
    }

    public mutating func updatePaymentDueDate(_ newDate: Int) {
        paymentDueDate = newDate
    }

    public mutating func updateStatementDate(_ newDate: Int) {
        statementDate = newDate
    }
}

public struct BankAccount: BaseAccount, Equatable, Identifiable {
    public typealias ID = Id

    public let id: Id
    public private(set) var name: DefaultLengthConstrainedString
    public let type: AccountType
    public let status: String
    public private(set) var icon: String?
    public let userId: Id
    public private(set) var balance: Money

    public init(
        id: Id,
        name: DefaultLengthConstrainedString,
        type: AccountType,
        status: String,
        icon: String?,
        userId: Id,
        balance: Money
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.status = status
        self.icon = icon
        self.userId = userId
        self.balance = balance
    }

    public mutating func updateName(_ newName: String) {
        name.update(newName)
    }

    public mutating func updateName(_ newName: DefaultLengthConstrainedString) {
        name = newName
    }

    public mutating func updateIcon(_ newIcon: String?) {
        icon = newIcon
    }

    public mutating func updateBalance(_ newBalance: Decimal) {
        balance.updateAmount(newBalance)
    }

    public mutating func updateBalance(_ newBalance: Money) {
        balance = newBalance
    }
}
