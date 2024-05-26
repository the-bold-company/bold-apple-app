// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
@testable import InvestmentFeature
import LiveMarketUseCase
import TestHelpers
import XCTest

@MainActor
final class StockSearchReducerTests: XCTestCase {
    private var initialState: StockSearchReducer.State!
    private var liveMarketUseCase: LiveMarketUseCaseInterfaceMock!
    private var store: TestStoreOf<StockSearchReducer>!
    private let testQueue = DispatchQueue.test

    override func setUpWithError() throws {
        initialState = StockSearchReducer.State()
        liveMarketUseCase = LiveMarketUseCaseInterfaceMock()
        liveMarketUseCase.searchSymbolSearchedStringStringDomainResultSymbolDisplayEntityReturnValue = .success([.tesla, .apple])
        store = TestStore(initialState: initialState) {
            StockSearchReducer(liveMarketUseCase: liveMarketUseCase)
        } withDependencies: {
            $0.mainQueue = testQueue.eraseToAnyScheduler()
        }
        store.exhaustivity = .off
    }

    func testRemoveSearchedText_MustClearSearchResult() async throws {
        // Act & Assert
        await store.send(.set(\.$searchedTerm, "something")) {
            $0.searchLoadingState = .loading
        }
        await store.send(.set(\.$searchedTerm, "")) {
            $0.searchLoadingState = .idle
        }
    }

    func testSearchSymbol_MustHave500msDebounce() async throws {
        // Act
        await searchSymbol(withStore: store)

        // Assert
        XCAssertNoDifference(liveMarketUseCase.searchSymbolSearchedStringStringDomainResultSymbolDisplayEntityReceivedInvocations, ["TSLA"])
        XCAssertNoDifference(liveMarketUseCase.searchSymbolSearchedStringStringDomainResultSymbolDisplayEntityCallsCount, 1)
    }

    func testSearchSymbolSuccess() async throws {
        // Act
        let searchTerm = await searchSymbol(withStore: store)

        // Assert
        await store.receive(\.delegate.searchResult) {
            $0.searchLoadingState = .loaded([
                SymbolDisplayEntity(symbol: Symbol(searchTerm), instrumentName: "Tesla Inc."),
                .apple,
            ])
        }
    }

    func testSearchSymbolFailure() async throws {
        // Arrange
        liveMarketUseCase.searchSymbolSearchedStringStringDomainResultSymbolDisplayEntityReturnValue = .failure(DomainError.custom(description: "Something is wrong"))

        // Act
        await searchSymbol(withStore: store)

        // Assert
        await store.receive(\.delegate.searchFailed) {
            $0.searchLoadingState = .failure(DomainError.custom(description: "Something is wrong"))
        }
    }

    @discardableResult
    private func searchSymbol(withStore store: TestStoreOf<StockSearchReducer>) async -> String {
        await store.send(.set(\.$searchedTerm, "T"))
        await testQueue.advance(by: .milliseconds(100))
        await store.send(.set(\.$searchedTerm, "TS"))
        await testQueue.advance(by: .milliseconds(100))
        await store.send(.set(\.$searchedTerm, "TSL"))
        await testQueue.advance(by: .milliseconds(100))
        await store.send(.set(\.$searchedTerm, "TSLA"))
        await testQueue.advance(by: .milliseconds(500))

        return store.state.searchedTerm
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
