import Factory
import InvestmentUseCase

public final class InvestmentFeatureContainer: SharedContainer {
    public static let shared = InvestmentFeatureContainer()
    public let manager = ContainerManager()
}

public extension InvestmentFeatureContainer {
    var investmentHomeReducer: Factory<InvestmentHomeReducer?> { self { nil } }
    var investmentPortfolioReducer: Factory<InvestmentPortfolioReducer?> { self { nil } }
    var investmentTradeImportOptionsReducer: Factory<InvestmentTradeImportOptionsReducer?> { self { nil } }
    var addInvestmentTradeReducer: Factory<RecordPortfolioTransactionReducer?> { self { nil } }
    var recordPortfolioTransactionReducer: Factory<RecordPortfolioTransactionReducer?> { self { nil } }
    var currencyPickerReducer: Factory<CurrencyPickerReducer?> { self { nil } }
    var investmentCashBalanceReducer: Factory<InvestmentCashBalanceReducer?> { self { nil } }
    var investmentTradeAssetPickerReducer: Factory<InvestmentTradeAssetPickerReducer?> { self { nil } }
    var stockSearchHomeReducer: Factory<StockSearchHomeReducer?> { self { nil } }
    var stockSearchReducer: Factory<StockSearchReducer?> { self { nil } }
}
