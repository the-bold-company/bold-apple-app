// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
import DomainEntities
@testable import RecordTransactionFeature
import TestHelpers
import XCTest

@MainActor
final class FundPickerReducerTests: XCTestCase {
    private var initialState: FundPickerReducer.State!

    override func setUpWithError() throws {
        initialState = .init(funds: IdentifiedArray(uniqueElements: [FundEntity.eatOut, FundEntity.secondHome, FundEntity.payBills])
        )
    }

    func testSelectionIsNilByDefault() async throws {
        // Arrange
        let store = TestStore(initialState: initialState) {
            FundPickerReducer()
        }

        // Assert
        XCTAssertNil(store.state.selectedFund)
    }

    func testSelectionIsNonNilIfSpecified() async throws {
        // Arrange
        initialState = .init(
            funds: IdentifiedArray(uniqueElements: [FundEntity.eatOut, FundEntity.secondHome, FundEntity.payBills]),
            selection: FundEntity.secondHome.id
        )
        let store = TestStore(initialState: initialState) {
            FundPickerReducer()
        }

        // Assert
        XCAssertNoDifference(store.state.selectedFund, FundEntity.secondHome.id)
    }

    func testFundSelected() async throws {
        // Arrange
        let store = TestStore(initialState: initialState) {
            FundPickerReducer()
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.fundSelected(id: FundEntity.secondHome.id)) {
            $0.selectedFund = FundEntity.secondHome.id
        }
    }

    func testFundDeselected() async throws {
        // Arrange
        initialState = .init(
            funds: IdentifiedArray(uniqueElements: [FundEntity.eatOut, FundEntity.secondHome, FundEntity.payBills]),
            selection: FundEntity.secondHome.id
        )
        let store = TestStore(initialState: initialState) {
            FundPickerReducer()
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.removeSelection) {
            $0.selectedFund = nil
        }
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
