import Factory
import InvestmentUseCase

public final class InvestmentFeatureContainer: SharedContainer {
    public static let shared = InvestmentFeatureContainer()
    public let manager = ContainerManager()
}

public extension InvestmentFeatureContainer {
    var investmentUseCase: Factory<InvestmentUseCaseInterface?> { self { nil } }
    var investmentHomeReducer: Factory<InvestmentHomeReducer?> { self { nil } }
    var investmentPortfolioReducer: Factory<InvestmentPortfolioReducer?> { self { nil } }
    var investmentTradeImportOptionsReducer: Factory<InvestmentTradeImportOptionsReducer?> { self { nil } }
    var addInvestmentTradeReducer: Factory<AddPortfolioTransactionReducer?> { self { nil } }
}
