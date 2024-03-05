//
//  FundDetailsReducerTests.swift
//
//
//  Created by Hien Tran on 03/03/2024.
//

// swiftlint:disable line_length

import ComposableArchitecture
import FundDetailsUseCase
@testable import FundFeature
import TestHelpers
import XCTest

@MainActor
final class FundDetailsReducerTests: XCTestCase {
    private var initialState: FundDetailsReducer.State!
    var fundDetailsUseCase: FundDetailsUseCaseProtocolMock!

    override func setUpWithError() throws {
        initialState = .init(fund: FundEntity.freelance)
        fundDetailsUseCase = FundDetailsUseCaseProtocolMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadTransactionHistorySuccesfully() async throws {
        // Arrange
        fundDetailsUseCase.loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorReturnValue = .success(PaginationEntity(currentPage: 0, items: TransactionEntity.inoutLists5))

        let store = TestStore(initialState: initialState, reducer: {
            FundDetailsReducer(fundDetailsUseCase: fundDetailsUseCase)
        })
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.loadTransactionHistory))

        // Assert
        await store.receive(\.delegate.loadTransactionsSuccesfully) {
            $0.transactions = IdentifiedArray(uniqueElements: PaginationEntity(currentPage: 0, items: TransactionEntity.inoutLists5).items)
        }
    }

    func testLoadTransactionHistoryFailed() async throws {
        // Arrange
        fundDetailsUseCase.loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorClosure = { _, _ in
            return .failure(DomainError.custom(description: "An error"))
        }

        let store = TestStore(
            initialState: initialState,
            reducer: {
                FundDetailsReducer(fundDetailsUseCase: fundDetailsUseCase)
            }
        )
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.loadTransactionHistory))

        // Assert
        await store.receive(\.delegate.loadTransactionsFailure) {
            $0.transactionsLoadingState = .failure(DomainError.custom(description: "An error"))
        }
    }

    func testLoadFundDetailsSuccessfully() async throws {
        // Arrange
        fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorReturnValue = .success(FundEntity.freelance.updating(balance: 51000))

        let store = TestStore(initialState: initialState, reducer: {
            FundDetailsReducer(fundDetailsUseCase: fundDetailsUseCase)
        })
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.loadFundDetails))

        // Assert
        await store.receive(\.delegate.loadFundDetailsSuccesfully) {
            $0.fund = FundEntity.freelance.updating(balance: 51000)
        }
    }

    func testLoadFundDetailsFailed() async throws {
        // Arrange
        fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorClosure = { _ in

            return .failure(DomainError.custom(description: "error"))
        }

        let store = TestStore(initialState: initialState, reducer: {
            FundDetailsReducer(fundDetailsUseCase: fundDetailsUseCase)
        })
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.loadFundDetails))

        // Assert
        await store.receive(\.delegate.failedToLoadFundDetails) {
            $0.fundDetailsLoadingState = .failure(DomainError.custom(description: "error"))
        }
    }

    func testDeleteFundSuccessfully() async throws {
        // Arrange
        fundDetailsUseCase.deleteFundIdUUIDResultUUIDDomainErrorReturnValue = .success(UUID(uuidString: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15")!)

        let store = TestStore(
            initialState: initialState,
            reducer: {
                FundDetailsReducer(fundDetailsUseCase: fundDetailsUseCase)
            },
            withDependencies: {
                $0.dismiss = DismissEffect {}
            }
        )
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.deleteFundButtonTapped))

        // Assert
        await store.receive(\.delegate.deleteFundSuccesfully) {
            $0.fundDeletionState = .loaded(UUID(uuidString: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15")!)
        }
    }

    func testDeleteFundFailed() async throws {
        // Arrange
        fundDetailsUseCase.deleteFundIdUUIDResultUUIDDomainErrorClosure = { _ in .failure(DomainError.custom(description: "Error"))
        }
        let store = TestStore(initialState: initialState, reducer: {
            FundDetailsReducer(fundDetailsUseCase: fundDetailsUseCase)
        })
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.deleteFundButtonTapped))

        // Assert
        await store.receive(\.delegate.failedToDeleteFund) {
            $0.fundDeletionState = .failure(DomainError.custom(description: "Error"))
        }
    }

    func testTransactionListIsUpdated_WhenNewTransactionIsRecored() async throws {
        // Arrange
        fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorReturnValue = .success(FundEntity.freelance.updating(balance: 9_999_900_000))
        let store = TestStore(
            initialState: update(initialState) {
                $0.destination = .sendMoney(.init(sourceFund: FundEntity.freelance))
            },
            reducer: {
                FundDetailsReducer(fundDetailsUseCase: fundDetailsUseCase)
            }
        )
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.destination(.presented(.sendMoney(.transactionRecordedSuccessfully(TransactionEntity.spend2))))) {
            $0.transactions = IdentifiedArray(uniqueElements: [TransactionEntity.spend2])
        }
    }

    func testFundDetailsIsUpdated_WhenNewTransactionIsRecored() async throws {
        // Arrange
        fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorReturnValue = .success(FundEntity.freelance.updating(balance: 9_999_900_000))
        let store = TestStore(
            initialState: update(initialState) {
                $0.destination = .sendMoney(.init(sourceFund: FundEntity.freelance))
            },
            reducer: {
                FundDetailsReducer(fundDetailsUseCase: fundDetailsUseCase)
            }
        )
        store.exhaustivity = .off

        // Act
        await store.send(.destination(.presented(.sendMoney(.transactionRecordedSuccessfully(TransactionEntity.spend2)))))

        // Assert
        await store.receive(\.delegate.loadFundDetailsSuccesfully) {
            $0.fund = FundEntity.freelance.updating(balance: 9_999_900_000)
        }
    }
}

// swiftlint:enable line_length
