public enum InvestmentTransactionType: String {
    case deposit
    case withdraw

    public var displayText: String {
        switch self {
        case .deposit:
            return "Deposit"
        case .withdraw:
            return "Withdrawal"
        }
    }
}

public struct InvestmentTransactionEntity: Equatable, Identifiable {
    public let id: ID
    public let portfolioId: ID
    public let type: InvestmentTransactionType
    public let amount: Money
    public let timestamp: Int
    public let notes: String?
    public let reason: String
    public let tradeId: ID?
    public let fundId: ID?

    public init(
        id: ID,
        portfolioId: ID,
        type: InvestmentTransactionType,
        amount: Money,
        timestamp: Int,
        notes: String? = nil,
        reason: String,
        tradeId: ID? = nil,
        fundId: ID? = nil
    ) {
        self.id = id
        self.portfolioId = portfolioId
        self.type = type
        self.amount = amount
        self.timestamp = timestamp
        self.notes = notes
        self.reason = reason
        self.tradeId = tradeId
        self.fundId = fundId
    }
}
