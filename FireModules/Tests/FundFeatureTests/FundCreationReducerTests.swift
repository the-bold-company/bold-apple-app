//
//  FundCreationReducerTests.swift
//
//
//  Created by Hien Tran on 05/03/2024.
//

import ComposableArchitecture
import FundCreationUseCase
@testable import FundFeature
import TestHelpers
import XCTest

@MainActor
final class FundCreationReducerTests: XCTestCase {
    private var initialState: FundCreationReducer.State!
    var fundCreationUseCase: FundCreationUseCaseProtocolMock!

    override func setUpWithError() throws {
        initialState = FundCreationReducer.State()
        fundCreationUseCase = FundCreationUseCaseProtocolMock()
    }

    func testCreateFund_WithCorrectInputs() async throws {
        // Arrange
        fundCreationUseCase.createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReturnValue = .success(FundEntity.freelance)

        let store = TestStore(initialState: update(initialState) {
            $0.fundName = "Freelance"
            $0.description = "Freelance income"
            $0.balance = 10_000_000_000
        }) {
            FundCreationReducer(fundCreationUseCase: fundCreationUseCase)
        } withDependencies: {
            $0.dismiss = DismissEffect {}
        }
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.submitButtonTapped))

        // Assert
        await store.receive(\.delegate.fundCreatedSuccessfully) { _ in
            XCAssertNoDifference(
                self.fundCreationUseCase.createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorCallsCount,
                1
            )
            XCAssertNoDifference(
                self.fundCreationUseCase.createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReceivedArguments!.name,
                "Freelance"
            )
            XCAssertNoDifference(
                self.fundCreationUseCase.createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReceivedArguments!.balance,
                10_000_000_000
            )
            XCAssertNoDifference(
                self.fundCreationUseCase.createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReceivedArguments!.currency,
                "VND"
            )
            XCAssertNoDifference(
                self.fundCreationUseCase.createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReceivedArguments!.description,
                "Freelance income"
            )
        }
    }

    func testCreateFiatFundSuccessfully() async throws {
        // Arrange
        fundCreationUseCase.createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReturnValue = .success(FundEntity.freelance)

        let store = TestStore(initialState: initialState) {
            FundCreationReducer(fundCreationUseCase: fundCreationUseCase)
        } withDependencies: {
            $0.dismiss = DismissEffect {}
        }
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.submitButtonTapped))

        // Assert
        await store.receive(\.delegate.fundCreatedSuccessfully) {
            $0.loadingState = .loaded(FundEntity.freelance)
        }
    }

    func testCreateFiatFundFailed() async throws {
        // Arrange
        fundCreationUseCase.createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorClosure = { name, balance, currency, description in
            return .failure(DomainError.custom(description: "Failed to creat fund . Name: \(name), balance: \(balance), currency: \(currency), description: \(description!)"))
        }

        let store = TestStore(initialState: update(initialState) {
            $0.fundName = "Freelance"
            $0.description = "Freelance income"
            $0.balance = 10_000_000_000
        }) {
            FundCreationReducer(fundCreationUseCase: fundCreationUseCase)
        }
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.submitButtonTapped))

        // Assert
        await store.receive(\.delegate.failedToCreateFund) {
            $0.loadingState = .failure(DomainError.custom(description: "Failed to creat fund . Name: Freelance, balance: \(10_000_000_000), currency: VND, description: Freelance income"))
        }
    }
}
