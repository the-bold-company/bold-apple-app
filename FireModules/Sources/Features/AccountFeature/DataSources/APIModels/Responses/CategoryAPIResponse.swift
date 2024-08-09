import Codextended
import DomainEntities
import Foundation

public struct CategoryAPIResponse: Decodable {
    let id: String
    let type: String
    let icon: String?
    let name: String
    let parentId: String?

    public init(from decoder: any Decoder) throws {
        self.id = try decoder.decode("id")
        self.type = try decoder.decode("type")
        self.icon = try decoder.decodeIfPresent("icon")
        self.name = try decoder.decode("name")
        self.parentId = try decoder.decodeIfPresent("parentId")
    }
}

public extension CategoryAPIResponse {
    var asMoneyInCategoryEntity: MoneyInCategory? {
        guard let type = CategoryType(rawValue: type), type == .moneyIn else { return nil }

        return .init(
            id: Id(id),
            name: DefaultLengthConstrainedString(name),
            icon: icon,
            parentId: parentId != nil ? Id(parentId!) : nil
        )
    }

    var asMoneyOutCategoryEntity: MoneyOutCategory? {
        guard let type = CategoryType(rawValue: type), type == .moneyOut else { return nil }

        return .init(
            id: Id(id),
            name: DefaultLengthConstrainedString(name),
            icon: icon,
            parentId: parentId != nil ? Id(parentId!) : nil
        )
    }
}
