public enum InvestmentTransactionType: String {
    case deposit
    case withdraw
}

public struct InvestmentTransactionEntity: Equatable, Identifiable {
    public let id: ID
    public let portfolioId: ID
    public let type: InvestmentTransactionType
    public let amount: Money
    public let currency: Currency
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
        currency: Currency,
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
        self.currency = currency
        self.timestamp = timestamp
        self.notes = notes
        self.reason = reason
        self.tradeId = tradeId
        self.fundId = fundId
    }
}
