import DomainEntities
import Foundation

public struct Transaction: Equatable, Identifiable {
    public let id: Id
    public let type: TransactionType
    public let amount: Money
//    public let sourceAccountId: Id
//    public let sourceAccountName: DefaultLengthConstrainedString
//    public let destinationAccountId: Id
//    public let destinationAccountName: DefaultLengthConstrainedString
//    public let timeStamp: Timestamp
    public let name: DefaultLengthConstrainedString?
    public let note: DefaultLengthConstrainedString?
//    public let userId: Id
}

public enum TransactionType: String, Decodable {
    case moneyIn = "money-in"
    case moneyOut = "money-out"
    case intenalTransfer = "internal-transfer"
}
