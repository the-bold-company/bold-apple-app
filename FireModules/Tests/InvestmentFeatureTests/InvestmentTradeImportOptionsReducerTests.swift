// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
@testable import InvestmentFeature
import TestHelpers
import XCTest

@MainActor
final class InvestmentTradeImportOptionsReducerTests: XCTestCase {
    private var initialState: InvestmentTradeImportOptionsReducer.State!
    override func setUpWithError() throws {
        initialState = InvestmentTradeImportOptionsReducer.State()
    }

    func testSelectImportMethod_AbleToSelectManual_() async throws {
        // Arrange
        let store = TestStore(
            initialState: initialState,
            reducer: { InvestmentTradeImportOptionsReducer() }
        )
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.forward(.selectImportMethod(ImportOption.manual.id))) {
            $0.destination = .addTransactionRoute(.init())
        }
    }

    func testSelectImportMethod_SelectInDevelopementMethods_MustNavigateToUnderConstructionScreen() async throws {
        // Arrange
        let store = TestStore(
            initialState: initialState,
            reducer: { InvestmentTradeImportOptionsReducer() }
        )
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
