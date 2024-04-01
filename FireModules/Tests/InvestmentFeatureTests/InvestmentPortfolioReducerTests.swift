// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
@testable import InvestmentFeature
import InvestmentUseCase
import LiveMarketUseCase
import TestHelpers
import XCTest

@MainActor
final class InvestmentPortfolioReducerTests: XCTestCase {
    private var initialState: InvestmentPortfolioReducer.State!
    private var investmentUseCase: InvestmentUseCaseInterfaceMock!
    private var liveMarketUseCase: LiveMarketUseCaseInterfaceMock!
    private var store: TestStoreOf<InvestmentPortfolioReducer>!

    override func setUpWithError() throws {
        initialState = InvestmentPortfolioReducer.State(portfolio: InvestmentPortfolioEntity.stockPortfolio1)
        investmentUseCase = InvestmentUseCaseInterfaceMock()
        liveMarketUseCase = LiveMarketUseCaseInterfaceMock()
        liveMarketUseCase.convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityReturnValue = .success(
            CurrencyConversionEntity.convertMock(
                amount: Money(3000, currency: Currency(code: .australianDollar)),
                to: Currency(code: .unitedStatesDollar),
                rate: 0.75
            )
        )
        store = TestStore(initialState: initialState) {
            InvestmentPortfolioReducer(
                investmentUseCase: investmentUseCase,
                liveMarketUseCase: liveMarketUseCase
            )
        }
        store.exhaustivity = .off
    }

    func testOnApearAction_OnlyCallsAPIOnce_WhenStateIsIdle() async throws {
        // Act & Assert
        await store.send(.forward(.onAppear))
        XCAssertNoDifference(liveMarketUseCase.convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityCallsCount, 1)

        await store.send(.forward(.onAppear))
        XCAssertNoDifference(liveMarketUseCase.convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityCallsCount, 1)
    }

    func testCalculateAvailableCash_NotCallAPI_WhenBalanceIsEmpty() async throws {
        // Aranage
        initialState = InvestmentPortfolioReducer.State(portfolio: InvestmentPortfolioEntity.stockPortfolio)
        store = TestStore(initialState: initialState) {
            InvestmentPortfolioReducer(
                investmentUseCase: investmentUseCase,
                liveMarketUseCase: liveMarketUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.forward(.onAppear))
        XCAssertNoDifference(liveMarketUseCase.convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityCallsCount, 0)
    }

    func testCalculateAvailableCash_NotCallAPIAgain_WhenStateIsLoading() async throws {
        // Aranage
        store = TestStore(
            initialState: update(initialState) { $0.calculatingAvailableCashState = .loading }
        ) {
            InvestmentPortfolioReducer(
                investmentUseCase: investmentUseCase,
                liveMarketUseCase: liveMarketUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.forward(.onAppear))
        XCAssertNoDifference(liveMarketUseCase.convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityCallsCount, 0)
    }

    func testCalculateAvailableCash_ReturnError_WhenBalanceContainsInvalidCurrency() async throws {
        // Aranage
        store = TestStore(
            initialState: update(initialState) { $0.portfolio = InvestmentPortfolioEntity.invalidPortfolio1 }
        ) {
            InvestmentPortfolioReducer(
                investmentUseCase: investmentUseCase,
                liveMarketUseCase: liveMarketUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.forward(.onAppear)) {
            $0.calculatingAvailableCashState = .failure(DomainError(error: CurrencyValidationError.symbolNotFound))
        }
    }

    func testCalculateAvailableCash_ReturnError_WhenBalanceContainsCurrencyCodeNone() async throws {
        // Aranage
        store = TestStore(
            initialState: update(initialState) { $0.portfolio = InvestmentPortfolioEntity.invalidPortfolio }
        ) {
            InvestmentPortfolioReducer(
                investmentUseCase: investmentUseCase,
                liveMarketUseCase: liveMarketUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.forward(.onAppear)) {
            $0.calculatingAvailableCashState = .failure(DomainError(error: CurrencyValidationError.symbolNotFound))
        }
    }

    func testCalculateAvailableCashSuccessfully() async throws {
        // Aranage

        // Act
        await store.send(.forward(.onAppear))

        // Assert
        await store.receive(\.delegate.availableCashConverted) {
            $0.calculatingAvailableCashState = .loaded(Money(3250, currency: Currency(code: .unitedStatesDollar)))
        }
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
