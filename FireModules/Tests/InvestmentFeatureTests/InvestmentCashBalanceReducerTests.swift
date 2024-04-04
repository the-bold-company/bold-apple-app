// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
@testable import InvestmentFeature
import InvestmentUseCase
import TestHelpers
import XCTest

@MainActor
final class InvestmentCashBalanceReducerTests: XCTestCase {
    private var initialState: InvestmentCashBalanceReducer.State!
    private var investmentUseCase: InvestmentUseCaseInterfaceMock!
    private var store: TestStoreOf<InvestmentCashBalanceReducer>!

    override func setUpWithError() throws {
        initialState = InvestmentCashBalanceReducer.State(
            portfolio: InvestmentPortfolioEntity.stockPortfolio1,
            totalBalance: Money(3250, currency: Currency(code: .unitedStatesDollar))
        )
        investmentUseCase = InvestmentUseCaseInterfaceMock()
        investmentUseCase.getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityReturnValue = .success(.mock)
        store = TestStore(initialState: initialState) {
            InvestmentCashBalanceReducer(investmentUseCase: investmentUseCase)
        }
        store.exhaustivity = .off
    }

    func testOnAppear_OnlyCallAPI_WhenStateIsIdle_AndStateIsNotLoading() async throws {
        // Act
        await store.send(.forward(.onAppear)) {
            $0.transactionHistoryLoadingState = .loading
        }

        // Assert
        await store.receive(\.delegate.transactionHistoryLoaded)
    }

    func testOnAppear_NotCallAPI_WhenStateIsNotIdle() async throws {
        // Arrange
        store = TestStore(
            initialState: update(initialState) {
                $0.transactionHistoryLoadingState = .loaded([])
            },
            reducer: {
                InvestmentCashBalanceReducer(investmentUseCase: investmentUseCase)
            }
        )
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.onAppear))

        // Assert
        XCAssertNoDifference(investmentUseCase.getPortfolioListDomainResultInvestmentPortfolioEntityCallsCount, 0)
    }

    func testOnAppear_NotCallAPI_WhenStateIsLoading() async throws {
        // Arrange
        store = TestStore(
            initialState: update(initialState) {
                $0.transactionHistoryLoadingState = .loading
            },
            reducer: {
                InvestmentCashBalanceReducer(investmentUseCase: investmentUseCase)
            }
        )
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.onAppear))

        // Assert
        XCAssertNoDifference(investmentUseCase.getPortfolioListDomainResultInvestmentPortfolioEntityCallsCount, 0)
    }

    func testLoadTransactionHistorySuccessfully() async throws {
        // Act
        await store.send(.forward(.onAppear))

        // Assert

        await store.receive(\.delegate.transactionHistoryLoaded) {
            $0.transactionHistoryLoadingState = .loaded([
                InvestmentTransactionEntity(
                    id: ID(uuidString: "aa141987-86b4-4234-a856-aba33b5b95e1"),
                    portfolioId: InvestmentPortfolioEntity.stockPortfolio.id,
                    type: .deposit,
                    amount: Money(1000, currency: Currency(code: .unitedStatesDollar)),
                    timestamp: 0,
                    reason: ""
                ),
                InvestmentTransactionEntity(
                    id: ID(uuidString: "aa141987-86b4-4234-a856-aba33b5b1234"),
                    portfolioId: InvestmentPortfolioEntity.stockPortfolio.id,
                    type: .deposit,
                    amount: Money(500, currency: Currency(code: .dong)),
                    timestamp: 0,
                    reason: ""
                ),
                InvestmentTransactionEntity(
                    id: ID(uuidString: "aa141987-86b4-4234-a856-aba33b5b6789"),
                    portfolioId: InvestmentPortfolioEntity.stockPortfolio.id,
                    type: .deposit,
                    amount: Money(1000, currency: Currency(code: .singaporeDollar)),
                    timestamp: 0,
                    reason: ""
                ),
            ])
        }
    }

    func testLoadTransactionHistoryFailed() async throws {
        // Arrange
        investmentUseCase.getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityReturnValue = .failure(DomainError.custom(description: "An error has occured"))
        // Act
        await store.send(.forward(.onAppear))

        // Assert

        await store.receive(\.delegate.failedToLoadTransactionHistory) {
            $0.transactionHistoryLoadingState = .failure(DomainError.custom(description: "An error has occured"))
        }
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
