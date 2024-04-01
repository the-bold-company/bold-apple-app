// swiftlint:disable force_unwrapping

extension InvestmentFeatureContainer: AutoRegistering {
    public func autoRegister() {
        investmentUseCase.register { resolve(\.investmentUseCase) }
        investmentHomeReducer.register {
            InvestmentHomeReducer(investmentUseCase: self.investmentUseCase.resolve()!)
        }
        investmentPortfolioReducer.register {
            InvestmentPortfolioReducer(
                investmentUseCase: self.investmentUseCase.resolve()!,
                liveMarketUseCase: resolve(\.liveMarketUseCase)
            )
        }
        investmentTradeImportOptionsReducer.register {
            InvestmentTradeImportOptionsReducer()
        }
        addInvestmentTradeReducer.register {
            RecordPortfolioTransactionReducer(investmentUseCase: self.investmentUseCase.resolve()!)
        }

        currencyPickerReducer.register {
            CurrencyPickerReducer()
        }

        investmentCashBalanceReducer.register {
            InvestmentCashBalanceReducer()
        }
    }
}

// swiftlint:enable force_unwrapping
