// public struct Transaction: Equatable, Identifiable, Hashable {
//    public let id: UUID // TODO: Create a new data structure for ID. Don't use UUID because it automatically capitalize the string
//    public let timestamp: Int
//    public let sourceFundId: UUID
//    public let destinationFundId: UUID?
//    public let amount: Decimal
//    public let type: TransactionEntityType
//    public let userId: UUID
//    public let currency: String
//    public let description: String?
//
//    public init(
//        id: String,
//        timestamp: Int,
//        sourceFundId: String,
//        destinationFundId: String? = nil,
//        amount: Decimal,
//        type: String,
//        userId: String,
//        currency: String,
//        description: String? = nil
//    ) {
//        self.id = UUID(uuidString: id)! // swiftlint:disable:this force_unwrapping
//        self.timestamp = timestamp
//        self.sourceFundId = UUID(uuidString: sourceFundId)! // swiftlint:disable:this force_unwrapping
//        self.destinationFundId = UUID(uuidString: destinationFundId ?? "")
//        self.amount = amount
//        self.type = TransactionEntityType(rawValue: type)! // swiftlint:disable:this force_unwrapping
//        self.userId = UUID(uuidString: userId)! // swiftlint:disable:this force_unwrapping
//        self.currency = currency
//        self.description = description
//    }
// }

public enum TransactionType: String, Decodable {
    case moneyIn = "money-in"
    case moneyOut = "money-out"
    case intenalTransfer = "internal-transfer"
}
