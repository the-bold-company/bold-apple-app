// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
@testable import InvestmentFeature
import LiveMarketUseCase
import TestHelpers
import XCTest

@MainActor
final class StockSearchHomeReducerTests: XCTestCase {
    private var initialState: StockSearchHomeReducer.State!
    private var liveMarketUseCase: LiveMarketUseCaseInterfaceMock!
    private var store: TestStoreOf<StockSearchHomeReducer>!
    private let testQueue = DispatchQueue.test

    override func setUpWithError() throws {
        initialState = update(StockSearchHomeReducer.State()) {
            $0.destination = .stockSearchRoute(.init())
        }
        liveMarketUseCase = LiveMarketUseCaseInterfaceMock()
        liveMarketUseCase.searchSymbolSearchedStringStringDomainResultSymbolDisplayEntityReturnValue = .success([.tesla, .apple])

        store = TestStore(initialState: initialState) {
            StockSearchHomeReducer(liveMarketUseCase: liveMarketUseCase)
        }
        store.exhaustivity = .off
    }

    func testActiveSearch() async throws {
        // Arrange
        let stockSearchState = update(StockSearchReducer.State()) { $0.searchedTerm = "TSL" }
        initialState = update(StockSearchHomeReducer.State()) {
            $0.destination = .stockSearchRoute(stockSearchState)
        }
        store = TestStore(initialState: initialState) {
            StockSearchHomeReducer(liveMarketUseCase: liveMarketUseCase)
        }
        store.exhaustivity = .off

        // Act
        await store.send(.destination(.presented(.stockSearchRoute(.forward(.cancelButtonTapped)))))

        // Assert
        await store.receive(\.destination.dismiss) {
            $0.searchedTerm = "TSL"
        }
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
