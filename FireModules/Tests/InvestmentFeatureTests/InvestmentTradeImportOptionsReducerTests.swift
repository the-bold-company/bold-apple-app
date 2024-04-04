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
}

// swiftlint:enable line_length
// swiftlint:enable file_length
