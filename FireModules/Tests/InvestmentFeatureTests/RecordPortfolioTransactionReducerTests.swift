// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
import DomainEntities
@testable import InvestmentFeature
import InvestmentUseCase
import TestHelpers
import XCTest

@MainActor
final class RecordPortfolioTransactionReducerTests: XCTestCase {
    private var initialState: RecordPortfolioTransactionReducer.State!
    private var store: TestStore<RecordPortfolioTransactionReducer.State, RecordPortfolioTransactionReducer.Action>!
    private var investmentUseCase: InvestmentUseCaseInterfaceMock!

    override func setUpWithError() throws {
        initialState = RecordPortfolioTransactionReducer.State(portfolio: InvestmentPortfolioEntity.stockPortfolio)
        investmentUseCase = InvestmentUseCaseInterfaceMock()
        store = TestStore(initialState: initialState) {
            RecordPortfolioTransactionReducer(investmentUseCase: investmentUseCase)
        } withDependencies: {
            $0.dismiss = DismissEffect {}
        }
    }

    override func invokeTest() {
        withDependencies {
            $0.date.now = Date(timeIntervalSince1970: 0)
        } operation: {
            super.invokeTest()
        }
    }

    func testSelectCurrency_MustDismissAfter() async throws {
        // Arrange
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.openCurrencyPicker)) {
            $0.destination = .currencyPickerRoute(.init(currentlySelected: $0.currency))
        }

        await store.send(.destination(.presented(.currencyPickerRoute(.selectCurrency(Currency.vnd)))))

        // Assert
        await store.receive(\.destination.dismiss)
    }

    func testSelectCurrency() async throws {
        // Arrange
        store = TestStore(
            initialState: update(initialState) { $0.currency = Currency.usd }
        ) { RecordPortfolioTransactionReducer(investmentUseCase: investmentUseCase) }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.forward(.openCurrencyPicker))

        await store.send(.destination(.presented(.currencyPickerRoute(.selectCurrency(Currency.vnd))))) {
            $0.currency = Currency.vnd
        }
    }

    func testValidateForm_MustBeInvalid_WhenAmountIsNotGreaterThanZero() async throws {
        // Arrange
        store.exhaustivity = .off

        // Act && Assert
        await store.send(.set(\.$amount, 0)) {
            XCAssertNoDifference($0.isFormValid, false)
        }
    }

    func testAddTransaction_UnableToProceed_WhenFormIsInvalid() async throws {
        // Arrange
        investmentUseCase.recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReturnValue = .success(InvestmentTransactionEntity.stockTransaction)
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$amount, 0))
        await store.send(.forward(.addTransactionButtonTapped))

        // Assert
        XCAssertNoDifference(investmentUseCase.recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityCallsCount, 0)
    }

    func testAddTransactionSuccess() async throws {
        // Arrange
        investmentUseCase.recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReturnValue = .success(InvestmentTransactionEntity.stockTransaction)
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$amount, 100))
        await store.send(.forward(.addTransactionButtonTapped))

        // Assert
        await store.receive(\.delegate.transactionAdded) {
            $0.submissionState = .loaded(InvestmentTransactionEntity.stockTransaction)
        }
    }

    func testAddTransactionFailure() async throws {
        // Arrange
        let mockError = DomainError.custom(description: "An error has occured", reason: "An error has occured")
        investmentUseCase.recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReturnValue = .failure(mockError)
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$amount, 100))
        await store.send(.forward(.addTransactionButtonTapped))

        // Assert
        await store.receive(\.delegate.failedToAddTransaction) {
            $0.submissionState = .failure(DomainError.custom(description: "An error has occured", reason: "An error has occured"))
            $0.destination = .recordTransactionFailureAlert(
                AlertState {
                    TextState("Unable to record transaction")
                } actions: {
                    ButtonState(role: .cancel, action: .okButtonTapped) {
                        TextState("Ok")
                    }
                } message: {
                    TextState("An error has occured")
                }
            )
        }
        await store.send(.destination(.presented(.recordTransactionFailureAlert(.okButtonTapped)))) {
            $0.destination = nil
        }
    }

    func testAddTransaction_AmountHasToBeConvertedToDecimalBeforeSendingToServer() async throws {
        // Arrange
        investmentUseCase.recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReturnValue = .success(InvestmentTransactionEntity.stockTransaction)
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$amount, 1234))
        await store.send(.forward(.addTransactionButtonTapped))

        // Assert
        XCAssertNoDifference(investmentUseCase.recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReceivedArguments!.amount, 12.34)
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
