//
//  HomeReducerTests.swift
//
//
//  Created by Hien Tran on 01/03/2024.
//

// swiftlint:disable type_body_length

import ComposableArchitecture
import DomainEntities
import FundDetailsUseCase
@testable import FundFeature
import FundListUseCase
@testable import HomeFeature
import PortfolioUseCase
import TestHelpers
import TransactionListUseCase
import XCTest

@MainActor
final class HomeReducerTests: XCTestCase {
    private var initialState: HomeReducer.State!
    private var transactionListUseCase: TransactionListUseCaseProtocolMock!
    private var fundListUseCase: FundListUseCaseProtocolMock!
    private var portfolioUseCase: PortfolioUseCaseInterfaceMock!
    private var fundDetailsUseCase: FundDetailsUseCaseProtocolMock!
    private let mockNetworthEntity = NetworthEntity(networth: 1000, currency: "VND")

    override func setUpWithError() throws {
        initialState = .init()
        transactionListUseCase = TransactionListUseCaseProtocolMock()
        fundListUseCase = FundListUseCaseProtocolMock()
        portfolioUseCase = PortfolioUseCaseInterfaceMock()
        fundDetailsUseCase = FundDetailsUseCaseProtocolMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialState() {
        // Arrange
        let store = TestStore(
            initialState: initialState,
            reducer: {
                HomeReducer(
                    transactionListUseCase: transactionListUseCase,
                    fundListUseCase: fundListUseCase,
                    fundDetailsUseCase: fundDetailsUseCase,
                    portfolioUseCase: portfolioUseCase
                )
            }
        )

        // Assert
        XCAssertNoDifference(store.state.networthLoadingState, .idle)
        XCAssertNoDifference(store.state.transactionLoadingState, .idle)
        XCAssertNoDifference(store.state.fundLoadingState, .idle)
        XCAssertNoDifference(store.state.fundList, [])
        XCAssertNoDifference(store.state.transactionList, [])
    }

    func testOnAppearAction_NetworhIsAvailable_WhenLoadingPortfolioSuccessfully() async throws {
        // Arrange
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success([])
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success([])
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.vnd1000)
        let store = TestStore(
            initialState: initialState,
            reducer: {
                HomeReducer(
                    transactionListUseCase: transactionListUseCase,
                    fundListUseCase: fundListUseCase,
                    fundDetailsUseCase: fundDetailsUseCase,
                    portfolioUseCase: portfolioUseCase
                )
            }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.forward(.loadPortfolio))

        // Assert
        await store.receive(\.delegate.loadPortfolioSuccessfully) {
            $0.networthLoadingState = .loaded(NetworthEntity.vnd1000)
        }
    }

    func testOnAppearAction_FundListIsAvailable_WhenLoadingFundsSuccessfully() async throws {
        // Arrange
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success([])
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.vnd1000)
        let store = TestStore(
            initialState: initialState,
            reducer: {
                HomeReducer(
                    transactionListUseCase: transactionListUseCase,
                    fundListUseCase: fundListUseCase,
                    fundDetailsUseCase: fundDetailsUseCase,
                    portfolioUseCase: portfolioUseCase
                )
            }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.forward(.loadFundList))

        // Assert
        await store.receive(\.delegate.loadFundListSuccessfully) {
            $0.fundLoadingState = .loaded(FundEntity.fiatList1)
            $0.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
        }
    }

    func testOnAppearAction_TransactionHistoryIsAvailable_WhenLoadingTransactionsSuccessfully() async throws {
        // Arrange
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.vnd1000)
        let store = TestStore(
            initialState: initialState,
            reducer: {
                HomeReducer(
                    transactionListUseCase: transactionListUseCase,
                    fundListUseCase: fundListUseCase,
                    fundDetailsUseCase: fundDetailsUseCase,
                    portfolioUseCase: portfolioUseCase
                )
            }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.forward(.loadTransactionHistory))

        // Assert
        await store.receive(\.delegate.loadTransactionsSuccessfully) {
            let mostRecentFiveTransactions = Array(TransactionEntity.inoutLists5.prefix(3))
            $0.transactionLoadingState = .loaded(mostRecentFiveTransactions)
            $0.transactionList = IdentifiedArray(uniqueElements: mostRecentFiveTransactions)
        }
    }

    func testLoadTransactionsSuccessfully_OnlyTakeTheMostThreeRecentRecords() async throws {
        // Arrange
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.vnd1000)
        let store = TestStore(
            initialState: initialState,
            reducer: {
                HomeReducer(
                    transactionListUseCase: transactionListUseCase,
                    fundListUseCase: fundListUseCase,
                    fundDetailsUseCase: fundDetailsUseCase,
                    portfolioUseCase: portfolioUseCase
                )
            }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act & Assert
        await store.send(.delegate(.loadTransactionsSuccessfully(TransactionEntity.inoutLists5))) {
            XCAssertNoDifference($0.transactionList.count, 3)
            $0.transactionList = IdentifiedArray(uniqueElements: Array(TransactionEntity.inoutLists5.prefix(3)))
        }
    }

    func testupdateFundAction_FundMustBeUpdatedAccordingly() async throws {
        // Arrange
        initialState.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
        let store = TestStore(
            initialState: initialState,
            reducer: {
                HomeReducer(
                    transactionListUseCase: transactionListUseCase,
                    fundListUseCase: fundListUseCase,
                    fundDetailsUseCase: fundDetailsUseCase,
                    portfolioUseCase: portfolioUseCase
                )
            }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act & Assert
        let fundToBeUpdated = FundEntity.fiatList1[2].updating(balance: 123_000)

        await store.send(.delegate(.updateFund(fundToBeUpdated))) {
            $0.fundList = IdentifiedArray(uniqueElements: update(FundEntity.fiatList1) { fundList in
                fundList[2] = fundToBeUpdated
            })
        }
    }

    func testFundMustBeDeleted_WhenDeletingFromFundDetailPage() async throws {
        // Arrange
        let store = TestStore(
            initialState: update(initialState) {
                $0.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
                $0.destination = .fundDetailsRoute(.init(fund: FundEntity.fiatList1[2]))
            },
            reducer: {
                HomeReducer(
                    transactionListUseCase: transactionListUseCase,
                    fundListUseCase: fundListUseCase,
                    fundDetailsUseCase: fundDetailsUseCase,
                    portfolioUseCase: portfolioUseCase
                )
            }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act & Assert
        await store.send(.destination(.presented(.fundDetailsRoute(.delegate(.deleteFundSuccesfully(FundEntity.fiatList1[2].id)))))) {
            XCAssertNoDifference($0.fundList.count, 3)
            $0.fundList = IdentifiedArray(uniqueElements: update(FundEntity.fiatList1) {
                $0.remove(at: 2)
            })
        }
    }

    func testFundMustBeUpdated_WhenUpdatingSuccessfullyFromFundDetailsPage() async throws {
        // Arrange
        let store = TestStore(
            initialState: update(initialState) {
                $0.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
                $0.destination = .fundDetailsRoute(.init(fund: FundEntity.fiatList1[2]))
            },
            reducer: {
                HomeReducer(
                    transactionListUseCase: transactionListUseCase,
                    fundListUseCase: fundListUseCase,
                    fundDetailsUseCase: fundDetailsUseCase,
                    portfolioUseCase: portfolioUseCase
                )
            }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act & Assert
        let fundToBeUpdated = FundEntity.fiatList1[2].updating(balance: 123_000)

        await store.send(.destination(.presented(.fundDetailsRoute(.delegate(.loadFundDetailsSuccesfully(fundToBeUpdated)))))) {
            $0.fundList = IdentifiedArray(uniqueElements: update(FundEntity.fiatList1) {
                $0[2] = fundToBeUpdated
            })
        }
    }

    func testCallUpdateNetworth_WhenTransactionIsRecordedSuccessfully() async throws {
        // Arrange
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.usd2000)
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)

        let store = TestStore(
            initialState: update(initialState) {
                $0.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
                $0.destination = .fundDetailsRoute(
                    update(
                        FundDetailsReducer.State(fund: FundEntity.fiatList1[3]),
                        { $0.destination = .sendMoney(.init(sourceFund: FundEntity.fiatList1[3])) }
                    )
                )
            }
        ) {
            HomeReducer(
                transactionListUseCase: transactionListUseCase,
                fundListUseCase: fundListUseCase,
                fundDetailsUseCase: fundDetailsUseCase,
                portfolioUseCase: portfolioUseCase
            )
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
        }

        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.destination(.presented(.fundDetailsRoute(.destination(.presented(.sendMoney(.transactionRecordedSuccessfully(TransactionEntity.spend))))))))

        // Assert
        await store.receive(\.delegate.loadPortfolioSuccessfully) {
            XCAssertNoDifference(self.portfolioUseCase.getNetworthResultNetworthEntityDomainErrorCallsCount, 1)
            $0.networthLoadingState = .loaded(NetworthEntity.usd2000)
        }
    }

    func testCallUpdateTransaction_WhenTransactionIsRecordedSuccessfully() async throws {
        // Arrange
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.usd2000)
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)

        let store = TestStore(
            initialState: update(initialState) {
                $0.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
                $0.destination = .fundDetailsRoute(
                    update(
                        FundDetailsReducer.State(fund: FundEntity.fiatList1[3]),
                        { $0.destination = .sendMoney(.init(sourceFund: FundEntity.fiatList1[3])) }
                    )
                )
            }
        ) {
            HomeReducer(
                transactionListUseCase: transactionListUseCase,
                fundListUseCase: fundListUseCase,
                fundDetailsUseCase: fundDetailsUseCase,
                portfolioUseCase: portfolioUseCase
            )
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
        }

        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.destination(.presented(.fundDetailsRoute(.destination(.presented(.sendMoney(.transactionRecordedSuccessfully(TransactionEntity.spend))))))))

        // Assert
        await store.receive(\.delegate.loadTransactionsSuccessfully) {
            XCAssertNoDifference(self.transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorCallsCount, 1)
            $0.transactionList = IdentifiedArray(uniqueElements: Array(TransactionEntity.inoutLists5.prefix(3)))
        }
    }

    func testCallUpdateDestinationFund_WhenTransactionIsRecordedSuccessfully_AndDestinationFundIsAvailable() async throws {
        // Arrange
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.usd2000)
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorReturnValue = .success(FundEntity.payBills.updating(balance: 100_000))

        let store = TestStore(
            initialState: update(initialState) {
                $0.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
                $0.destination = .fundDetailsRoute(
                    update(
                        FundDetailsReducer.State(fund: FundEntity.fiatList1[3]),
                        { $0.destination = .sendMoney(.init(sourceFund: FundEntity.fiatList1[3])) }
                    )
                )
            }
        ) {
            HomeReducer(
                transactionListUseCase: transactionListUseCase,
                fundListUseCase: fundListUseCase,
                fundDetailsUseCase: fundDetailsUseCase,
                portfolioUseCase: portfolioUseCase
            )
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
        }

        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.destination(.presented(.fundDetailsRoute(.destination(.presented(.sendMoney(.transactionRecordedSuccessfully(TransactionEntity.transfer))))))))

        // Assert
        await store.receive(\.delegate.updateFund) {
            XCAssertNoDifference(self.fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorCallsCount, 1)
            $0.fundList[id: FundEntity.payBills.id] = FundEntity.payBills.updating(balance: 100_000)
        }
    }

    func testDoesNotCallUpdateDestinationFund_WhenTransactionIsRecordedSuccessfully_AndDestinationFundIsUnavailable() async throws {
        // Arrange
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.usd2000)
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorReturnValue = .success(FundEntity.payBills.updating(balance: 100_000))

        let store = TestStore(
            initialState: update(initialState) {
                $0.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
                $0.destination = .fundDetailsRoute(
                    update(
                        FundDetailsReducer.State(fund: FundEntity.fiatList1[3]),
                        { $0.destination = .sendMoney(.init(sourceFund: FundEntity.fiatList1[3])) }
                    )
                )
            }
        ) {
            HomeReducer(
                transactionListUseCase: transactionListUseCase,
                fundListUseCase: fundListUseCase,
                fundDetailsUseCase: fundDetailsUseCase,
                portfolioUseCase: portfolioUseCase
            )
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
        }

        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.destination(.presented(.fundDetailsRoute(.destination(.presented(.sendMoney(.transactionRecordedSuccessfully(TransactionEntity.spend))))))))

        // Assert
        XCAssertNoDifference(store.state.fundList, IdentifiedArray(uniqueElements: FundEntity.fiatList1))
    }

    func testFundListIsUpdated_WhenNewFundIsCreatedSuccessfully() async throws {
        // Arrange
        let store = TestStore(initialState: update(initialState) {
            $0.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
            $0.destination = .fundCreationRoute(.init())
        }) {
            HomeReducer(
                transactionListUseCase: transactionListUseCase,
                fundListUseCase: fundListUseCase,
                fundDetailsUseCase: fundDetailsUseCase,
                portfolioUseCase: portfolioUseCase
            )
        }

        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act & Assert
        var newList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
        newList.append(FundEntity.example1)
        await store.send(.destination(.presented(.fundCreationRoute(.fundCreatedSuccessfully(FundEntity.example1))))) {
            $0.fundList = IdentifiedArray(
                uniqueElements: update(
                    IdentifiedArray(uniqueElements: FundEntity.fiatList1),
                    { $0.append(FundEntity.example1) }
                )
            )
        }
    }
}

// swiftlint:enable type_body_length
