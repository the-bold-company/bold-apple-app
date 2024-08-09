import Codextended
import DomainEntities
import Foundation

public struct TransactionAPIResponse: Decodable {
    public let id: String
    public let type: TransactionType
    public let amount: Decimal
    public let accountId: String
    public let accountName: String
    public let data: String
    public let categoryId: String?
    public let name: String?
    public let note: String?
    public let userId: String

    public init(from decoder: any Decoder) throws {
        self.id = try decoder.decode("id")
        self.type = try decoder.decode("type")
        self.amount = try decoder.decode("amount")
        self.accountId = try decoder.decode("accountId")
        self.accountName = try decoder.decode("accountName")
        self.data = try decoder.decode("transferDate")
        self.categoryId = try decoder.decodeIfPresent("categoryId")
        self.name = try decoder.decodeIfPresent("name")
        self.note = try decoder.decodeIfPresent("note")
        self.userId = try decoder.decode("userId")
    }
}
