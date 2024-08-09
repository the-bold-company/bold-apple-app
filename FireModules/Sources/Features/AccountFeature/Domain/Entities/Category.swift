import DomainEntities
import Foundation
import IdentifiedCollections

public enum CategoryType: String {
    case moneyIn = "money-in"
    case moneyOut = "money-out"
}

public protocol Category {
    var id: Id { get }
    var name: DefaultLengthConstrainedString { get }
    var type: CategoryType { get }
    var icon: String? { get }
    var parentId: Id? { get }
}

public struct AnyCategory: Category, Equatable, Identifiable {
    public typealias ID = Id

    private var wrapped: Category

    public var id: Id { wrapped.id }
    public var type: CategoryType { wrapped.type }
    public var name: DefaultLengthConstrainedString { wrapped.name }
    public var icon: String? { wrapped.icon }
    public var parentId: Id? { wrapped.parentId }

    public init(_ wrapped: Category) {
        self.wrapped = wrapped
    }

    public static func == (lhs: AnyCategory, rhs: AnyCategory) -> Bool {
        return lhs.id == rhs.id
            && lhs.type == rhs.type
            && lhs.name == rhs.name
            && lhs.icon == rhs.icon
            && lhs.parentId == rhs.parentId
    }
}

public struct MoneyInCategory: Category, Equatable, Identifiable {
    public typealias ID = Id

    public let id: Id
    public let type: CategoryType = .moneyIn
    public private(set) var name: DefaultLengthConstrainedString
    public private(set) var icon: String?
    public let parentId: Id?

    public init(
        id: Id,
        name: DefaultLengthConstrainedString,
        icon: String? = nil,
        parentId: Id? = nil
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.parentId = parentId
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
}

public extension MoneyInCategory {
    func eraseToAnyCategory() -> AnyCategory {
        AnyCategory(self)
    }
}

public extension MoneyInCategory {
    static let undefined = MoneyInCategory(
        id: Id("00000000-0000-0000-0000-000000000000"),
        name: DefaultLengthConstrainedString("Không xác định")
    )
}

public struct MoneyOutCategory: Category, Equatable, Identifiable {
    public typealias ID = Id

    public let id: Id
    public let type: CategoryType = .moneyOut
    public private(set) var name: DefaultLengthConstrainedString
    public private(set) var icon: String?
    public let parentId: Id?

    public init(
        id: Id,
        name: DefaultLengthConstrainedString,
        icon: String? = nil,
        parentId: Id? = nil
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.parentId = parentId
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
}

public extension MoneyOutCategory {
    static let undefined = MoneyOutCategory(
        id: Id("00000000-0000-0000-0000-000000000000"),
        name: DefaultLengthConstrainedString("Không xác định")
    )
}
