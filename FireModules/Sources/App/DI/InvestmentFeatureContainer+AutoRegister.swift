// swiftlint:disable force_unwrapping

extension InvestmentFeatureContainer: AutoRegistering {
    public func autoRegister() {
        investmentHomeReducer.register {
            InvestmentHomeReducer(investmentUseCase: resolve(\.investmentUseCase))
        }
        investmentPortfolioReducer.register {
            InvestmentPortfolioReducer(
                investmentUseCase: resolve(\.investmentUseCase),
                liveMarketUseCase: resolve(\.liveMarketUseCase)
            )
        }
        investmentTradeImportOptionsReducer.register {
            InvestmentTradeImportOptionsReducer()
        }
        addInvestmentTradeReducer.register {
            RecordPortfolioTransactionReducer(investmentUseCase: resolve(\.investmentUseCase))
        }

        currencyPickerReducer.register {
            CurrencyPickerReducer()
        }

        investmentCashBalanceReducer.register {
            InvestmentCashBalanceReducer(investmentUseCase: resolve(\.investmentUseCase))
        }

        investmentTradeAssetPickerReducer.register {
            InvestmentTradeAssetPickerReducer()
        }

        stockSearchReducer.register {
            StockSearchReducer(liveMarketUseCase: resolve(\.liveMarketUseCase))
        }
    }
}

// swiftlint:enable force_unwrapping
