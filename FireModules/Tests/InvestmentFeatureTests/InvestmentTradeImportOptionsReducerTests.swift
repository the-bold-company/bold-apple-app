// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
import DomainEntities
@testable import InvestmentFeature
import TestHelpers
import XCTest

@MainActor
final class InvestmentTradeImportOptionsReducerTests: XCTestCase {
    private var initialState: InvestmentTradeImportOptionsReducer.State!
    private var store: TestStoreOf<InvestmentTradeImportOptionsReducer>!
    override func setUpWithError() throws {
        initialState = InvestmentTradeImportOptionsReducer.State(portfolio: InvestmentPortfolioEntity.stockPortfolio)
        store = TestStore(
            initialState: initialState,
            reducer: { InvestmentTradeImportOptionsReducer() }
        )
    }

    func testSelectImportMethod_SelectInDevelopementMethods_MustNavigateToUnderConstructionScreen() async throws {
        // Arrange
        store.exhaustivity = .off

        // Act & Assert
        for option in store.state.importOptions where option != ImportOption.manual {
            await store.send(.forward(.selectImportMethod(option.id))) {
                $0.destination = .underConstructionRoute
            }

            await store.send(.destination(.dismiss))
        }
    }

    func testRecordTransactionSuccessfully_MustDismiss() async throws {
        // Arrange
        store = TestStore(
            initialState: update(initialState) {
                $0.destination = .addTransactionRoute(.init(portfolio: InvestmentPortfolioEntity.stockPortfolio))
            },
            reducer: { InvestmentTradeImportOptionsReducer() }
        )
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.destination(.presented(.addTransactionRoute(.delegate(.transactionAdded(InvestmentTransactionEntity.stockTransaction))))))
        await store.receive(\.destination.dismiss)
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
