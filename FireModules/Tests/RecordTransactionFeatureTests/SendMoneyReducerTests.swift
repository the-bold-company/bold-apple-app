// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
import FundListUseCase
@testable import RecordTransactionFeature
import TestHelpers
import TransactionRecordUseCase
import XCTest

@MainActor
final class SendMoneyReducerTests: XCTestCase {
    private var initialState: SendMoneyReducer.State!
    private var transactionRecordUseCase: TransactionRecordUseCaseProtocolMock!
    private var fundListUseCase: FundListUseCaseProtocolMock!

    override func setUpWithError() throws {
        initialState = SendMoneyReducer.State(sourceFund: FundEntity.freelance)
        transactionRecordUseCase = TransactionRecordUseCaseProtocolMock()
        fundListUseCase = FundListUseCaseProtocolMock()
    }

    func testOnAppear_LoadTargetFundsSuccessfully() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        let store = TestStore(initialState: initialState) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        }
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.onAppear))

        // Assert
        await store.receive(\.delegate.targetFundsLoaded) {
            $0.targetFunds = update(IdentifiedArray(uniqueElements: FundEntity.fiatList1)) {
                $0.remove(id: FundEntity.freelance.id)
            }
        }
    }

    func testDestinationFundSelected() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        let store = TestStore(initialState: update(initialState) {
            let destinationFunds = IdentifiedArray(uniqueElements: [FundEntity.eatOut, FundEntity.secondHome, FundEntity.payBills])

            $0.targetFunds = destinationFunds
            $0.fundPicker = .init(funds: destinationFunds)
        }) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.fundPicker(.presented(.saveSelection(id: FundEntity.eatOut.id)))) {
            $0.selectedTargetFund = FundEntity.eatOut
        }
    }

    func testDestinationFundDeselected() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        let store = TestStore(initialState: update(initialState) {
            let destinationFunds = IdentifiedArray(uniqueElements: [FundEntity.eatOut, FundEntity.secondHome, FundEntity.payBills])

            $0.targetFunds = destinationFunds
            $0.fundPicker = .init(funds: destinationFunds)
        }) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.fundPicker(.presented(.saveSelection(id: nil)))) {
            $0.selectedTargetFund = nil
        }
    }

    func testDefaultTransactionMessage_WhenDestinationFundIsSelected() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        let store = TestStore(initialState: update(initialState) {
            let destinationFunds = IdentifiedArray(uniqueElements: [FundEntity.eatOut, FundEntity.secondHome, FundEntity.payBills])

            $0.targetFunds = destinationFunds
            $0.fundPicker = .init(funds: destinationFunds)
        }) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.fundPicker(.presented(.saveSelection(id: FundEntity.eatOut.id)))) {
            $0.description = "Transfer from 'Freelance' to 'Eat out'"
        }
    }

    func testDefaultTransactionMessage_WhenDestinationFundDeselected() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        let store = TestStore(initialState: update(initialState) {
            let destinationFunds = IdentifiedArray(uniqueElements: [FundEntity.eatOut, FundEntity.secondHome, FundEntity.payBills])

            $0.targetFunds = destinationFunds
            $0.fundPicker = .init(funds: destinationFunds)
        }) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.fundPicker(.presented(.saveSelection(id: nil)))) {
            $0.description = "Transfer from 'Freelance'"
        }
    }

    func testFormIsInvalid_WhenTheAmountIsNotGreaterThanZero() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        let store = TestStore(initialState: initialState) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.set(\.$amount, 0)) {
            $0.isFormValid = false
        }
    }

    func testFormIsInvalid_WhenTheAmountIsGreaterThanSourceBalance() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        let store = TestStore(initialState: initialState) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.set(\.$amount, 11_000_000_000)) {
            $0.isFormValid = false
        }
    }

    func testFormIsValid_WhenAllConditionsAreMet() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        let store = TestStore(initialState: initialState) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.set(\.$amount, 9_000_000_000)) {
            $0.isFormValid = true
        }
    }

    func testSendMoneySuccessfully() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        transactionRecordUseCase.recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.spend)
        let store = TestStore(initialState: update(initialState) {
            $0.amount = 1_000_000
        }) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        } withDependencies: {
            $0.dismiss = DismissEffect {}
        }
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.proceedButtonTapped))

        // Assert
        await store.receive(\.delegate.transactionRecordedSuccessfully) {
            $0.transactionRecordLoadingState = .loaded(TransactionEntity.spend)
        }
    }

    func testSendmoneyFailed() async throws {
        // Arrange
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        transactionRecordUseCase.recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorClosure = { sourceId, amount, _, _ in
            return .failure(DomainError.custom(description: "Failed to transfer amount \(amount) from '\(sourceId.uuidString.lowercased())'"))
        }
        let store = TestStore(initialState: update(initialState) {
            $0.amount = 1_000_000
        }) {
            SendMoneyReducer(
                transactionRecordUseCase: transactionRecordUseCase,
                fundListUseCase: fundListUseCase
            )
        } withDependencies: {
            $0.dismiss = DismissEffect {}
        }
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.proceedButtonTapped))

        // Assert
        await store.receive(\.delegate.transactionRecordedFailed) {
            $0.transactionRecordLoadingState = .failure(DomainError.custom(description: "Failed to transfer amount \(1_000_000) from 'd8394718-9e23-4680-a30c-2a0b14efd695'"))
        }
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
