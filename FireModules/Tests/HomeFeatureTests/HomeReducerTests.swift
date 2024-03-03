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

    func testOnAppearAction_OnlyLoadsInfo_WhenLoadingStatesAreIdle() async throws {
        // Arrange
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success([])
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success([])
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.usd2000)
        let store = TestStore(
            initialState: initialState,
            reducer: {
                HomeReducer(
                    transactionListUseCase: transactionListUseCase,
                    fundListUseCase: fundListUseCase,
                    fundDetailsUseCase: FundDetailsUseCaseProtocolMock(),
                    portfolioUseCase: portfolioUseCase
                )
            }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.delegate(.onAppear))

        // Assert
        XCAssertNoDifference(transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorCallsCount, 1)
        XCAssertNoDifference(fundListUseCase.getFiatFundListResultFundEntityDomainErrorCallsCount, 1)
        XCAssertNoDifference(portfolioUseCase.getNetworthResultNetworthEntityDomainErrorCallsCount, 1)
    }

    func testOnAppearAction_OnlyLoadsInfoOnce_WhenTriggeredMultipleTimes() async throws {
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
        await store.send(.delegate(.onAppear))
        await store.send(.delegate(.onAppear))
        await store.send(.delegate(.onAppear))

        // Assert
        XCAssertNoDifference(transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorCallsCount, 1)
        XCAssertNoDifference(fundListUseCase.getFiatFundListResultFundEntityDomainErrorCallsCount, 1)
        XCAssertNoDifference(portfolioUseCase.getNetworthResultNetworthEntityDomainErrorCallsCount, 1)
    }

    func testOnAppearAction_FailsToLoadNetworth_TheRestStillProceedSuccessfully() async throws {
        // Arrange
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success([])
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success([])
        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorClosure = {
            return .failure(DomainError.custom(description: "Something's wrong"))
        }
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
        await store.send(.delegate(.onAppear))

        // Assert
        await store.receive(/HomeReducer.Action.forward(.loadFundListSuccessfully([])))
        await store.receive(/HomeReducer.Action.forward(.loadTransactionsSuccessfully([])))
    }

    func testOnAppearAction_FailsToLoadFundList_TheRestStillProceedSuccessfully() async throws {
        // Arrange
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success([])
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorClosure = {
            return .failure(DomainError.custom(description: "Something's wrong"))
        }
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
        await store.send(.delegate(.onAppear))

        // Assert
        await store.receive(/HomeReducer.Action.forward(.loadPortfolioSuccessfully(NetworthEntity(networth: 1000, currency: "VND"))))
        await store.receive(/HomeReducer.Action.forward(.loadTransactionsSuccessfully([])))
    }

    func testOnAppearAction_FailsToLoadTransactions_TheRestStillProceedSuccessfully() async throws {
        // Arrange
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorClosure = {
            return .failure(DomainError.custom(description: "Something's wrong"))
        }
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
        await store.send(.delegate(.onAppear))

        // Assert
        await store.receive(/HomeReducer.Action.forward(.loadPortfolioSuccessfully(NetworthEntity(networth: 1000, currency: "VND"))))
        await store.receive(/HomeReducer.Action.forward(.loadFundListSuccessfully([])))
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
        await store.send(.delegate(.onAppear))

        // Assert
        await store.receive(/HomeReducer.Action.forward(.loadPortfolioSuccessfully(NetworthEntity.dumb))) {
            $0.networthLoadingState = .loaded(NetworthEntity.vnd1000)
        }
        await store.receive(/HomeReducer.Action.forward(.loadFundListSuccessfully([])))
        await store.receive(/HomeReducer.Action.forward(.loadTransactionsSuccessfully([])))
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
        await store.send(.delegate(.onAppear))

        // Assert
        await store.receive(/HomeReducer.Action.forward(.loadPortfolioSuccessfully(NetworthEntity.dumb)))
        await store.receive(/HomeReducer.Action.forward(.loadFundListSuccessfully([]))) {
            $0.fundLoadingState = .loaded(FundEntity.fiatList1)
        }
        await store.receive(/HomeReducer.Action.forward(.loadTransactionsSuccessfully([])))
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
        await store.send(.delegate(.onAppear))

        // Assert
        await store.receive(/HomeReducer.Action.forward(.loadPortfolioSuccessfully(NetworthEntity.dumb)))
        await store.receive(/HomeReducer.Action.forward(.loadFundListSuccessfully([])))
        await store.receive(/HomeReducer.Action.forward(.loadTransactionsSuccessfully([]))) {
            $0.transactionLoadingState = .loaded(Array(TransactionEntity.inoutLists5.prefix(3)))
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
        await store.send(.forward(.loadTransactionsSuccessfully(TransactionEntity.inoutLists5))) {
            let mostRecentTransactions = Array(TransactionEntity.inoutLists5.prefix(3))
            XCAssertNoDifference($0.transactionList.count, 3)
            $0.transactionList = IdentifiedArray(uniqueElements: mostRecentTransactions)
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
        var newList = FundEntity.fiatList1
        newList[2] = fundToBeUpdated

        await store.send(.forward(.updateFund(fundToBeUpdated))) {
            $0.fundList = IdentifiedArray(uniqueElements: newList)
        }
    }

    func testFundMustBeDeleted_WhenDeletingFromFundDetailPage() async throws {
        // Arrange
        initialState.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
        initialState.destination = .fundDetailsRoute(.init(fund: FundEntity.fiatList1[2]))

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

        var newList = FundEntity.fiatList1
        newList[2] = fundToBeUpdated
        var afterRemove = FundEntity.fiatList1
        afterRemove.remove(at: 2)
        await store.send(.destination(.presented(.fundDetailsRoute(.forward(.deleteFundSuccesfully(FundEntity.fiatList1[2].id)))))) {
            XCAssertNoDifference($0.fundList.count, 3)
            $0.fundList = IdentifiedArray(uniqueElements: afterRemove)
        }
    }

    func testFundMustBeUpdated_WhenUpdatingSuccessfullyFromFundDetailsPage() async throws {
        // Arrange
        initialState.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
        initialState.destination = .fundDetailsRoute(.init(fund: FundEntity.fiatList1[2]))

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
        var newList = FundEntity.fiatList1
        newList[2] = fundToBeUpdated

        await store.send(.destination(.presented(.fundDetailsRoute(.forward(.fundDetailsUpdated(fundToBeUpdated))))))

        // Assert
        await store.receive(/HomeReducer.Action.forward(.updateFund(fundToBeUpdated))) {
            $0.fundList = IdentifiedArray(uniqueElements: newList)
        }
    }

    func testCallUpdateNetworth_WhenTransactionIsRecordedSuccessfully() async throws {
        // Arrange
        var fundDetailsState = FundDetailsReducer.State(fund: FundEntity.fiatList1[3])
        fundDetailsState.destination = .sendMoney(.init(sourceFund: FundEntity.fiatList1[3]))
        initialState.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
        initialState.destination = .fundDetailsRoute(fundDetailsState)

        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.usd2000)
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)

        let store = TestStore(initialState: initialState) {
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
        XCAssertNoDifference(portfolioUseCase.getNetworthResultNetworthEntityDomainErrorCallsCount, 1)
        await store.receive(/HomeReducer.Action.forward(.loadPortfolioSuccessfully(NetworthEntity.dumb))) {
            $0.networthLoadingState = .loaded(NetworthEntity.usd2000)
        }
    }

    func testCallUpdateTransaction_WhenTransactionIsRecordedSuccessfully() async throws {
        // Arrange
        var fundDetailsState = FundDetailsReducer.State(fund: FundEntity.fiatList1[3])
        fundDetailsState.destination = FundDetailsReducer.Destination.State.sendMoney(.init(sourceFund: FundEntity.fiatList1[3]))
        initialState.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
        initialState.destination = .fundDetailsRoute(fundDetailsState)

        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.usd2000)
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundListUseCase.getFiatFundListResultFundEntityDomainErrorReturnValue = .success(FundEntity.fiatList1)

        let store = TestStore(initialState: initialState) {
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
        XCAssertNoDifference(transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorCallsCount, 1)
        await store.receive(/HomeReducer.Action.forward(.loadTransactionsSuccessfully(TransactionEntity.inoutLists5)))
    }

    func testCallUpdateDestinationFund_WhenTransactionIsRecordedSuccessfully_AndDestinationFundIsAvailable() async throws {
        // Arrange
        var fundDetailsState = FundDetailsReducer.State(fund: FundEntity.fiatList1[3])
        fundDetailsState.destination = FundDetailsReducer.Destination.State.sendMoney(.init(sourceFund: FundEntity.fiatList1[3]))
        initialState.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
        initialState.destination = .fundDetailsRoute(fundDetailsState)

        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.usd2000)
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorReturnValue = .success(FundEntity.payBills.updating(balance: 100_000))

        let store = TestStore(initialState: initialState) {
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
        await store.receive(/HomeReducer.Action.forward(.loadPortfolioSuccessfully(NetworthEntity.usd2000)))
        await store.receive(/HomeReducer.Action.forward(.loadTransactionsSuccessfully(TransactionEntity.inoutLists5)))
        XCAssertNoDifference(fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorCallsCount, 1)
        await store.receive(/HomeReducer.Action.forward(.updateFund(FundEntity.payBills.updating(balance: 100_000)))) {
            $0.fundList[id: FundEntity.payBills.updating(balance: 100_000).id] = FundEntity.payBills.updating(balance: 100_000)
        }
    }

    func testDoesNotCallUpdateDestinationFund_WhenTransactionIsRecordedSuccessfully_AndDestinationFundIsUnavailable() async throws {
        // Arrange
        var fundDetailsState = FundDetailsReducer.State(fund: FundEntity.fiatList1[3])
        fundDetailsState.destination = FundDetailsReducer.Destination.State.sendMoney(.init(sourceFund: FundEntity.fiatList1[3]))
        initialState.fundList = IdentifiedArray(uniqueElements: FundEntity.fiatList1)
        initialState.destination = .fundDetailsRoute(fundDetailsState)

        portfolioUseCase.getNetworthResultNetworthEntityDomainErrorReturnValue = .success(NetworthEntity.usd2000)
        transactionListUseCase.getInOutTransactionsResultTransactionEntityDomainErrorReturnValue = .success(TransactionEntity.inoutLists5)
        fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorReturnValue = .success(FundEntity.payBills.updating(balance: 100_000))

        let store = TestStore(initialState: initialState) {
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
        XCAssertNoDifference(fundDetailsUseCase.loadFundDetailsIdUUIDResultFundEntityDomainErrorCallsCount, 0)
    }
}

extension NetworthEntity {
    static var vnd1000: NetworthEntity { NetworthEntity(networth: 1000, currency: "VND") }
    static var usd2000: NetworthEntity { NetworthEntity(networth: 2000, currency: "USD") }
    static let dumb = NetworthEntity(networth: 0, currency: "GBP")
}

extension FundEntity {
    static var fiatList1: [FundEntity] {
        [
            FundEntity(
                id: "c25d7db0-9944-42bd-9252-e4d240590ce2",
                balance: 100,
                name: "Eat out",
                currency: "USD",
                fundType: "fiat"
            ),
            FundEntity(
                id: "abd5eedf-dd1d-41fd-95dd-beb803c20006",
                balance: 10_000_000,
                name: "2nd Home",
                currency: "SGD",
                fundType: "fiat"
            ),
            FundEntity(
                id: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
                balance: 0,
                name: "Pay bills",
                currency: "VND",
                fundType: "fiat"
            ),
            FundEntity(
                id: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                balance: 10_000_000_000,
                name: "Freelance",
                currency: "VND",
                fundType: "fiat"
            ),
        ]
    }

    static let payBills = FundEntity(
        id: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
        balance: 0,
        name: "Pay bills",
        currency: "VND",
        fundType: "fiat"
    )

    func updating(
        balance: Decimal? = nil,
        name: String? = nil,
        description: String? = nil
    ) -> FundEntity {
        return FundEntity(
            uuid: id,
            balance: balance ?? self.balance,
            name: name ?? self.name,
            currency: currency,
            description: description ?? self.description,
            fundType: fundType.rawValue
        )
    }
}

extension TransactionEntity {
    static var inoutLists5: [TransactionEntity] {
        [
            TransactionEntity(
                id: "e8543567-fcda-4e85-a185-79762fa971ca",
                timestamp: 1_709_372_124,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                destinationFundId: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
            TransactionEntity(
                id: "aad4297b-63f4-425b-a76c-baa6b94ff12b",
                timestamp: 1_709_372_129,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                destinationFundId: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
            TransactionEntity(
                id: "f373c0a9-75d2-4387-967a-ab05a75b6bcc",
                timestamp: 1_709_372_159,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
            TransactionEntity(
                id: "534fedb2-322e-423b-a79a-9431d8053295",
                timestamp: 1_709_372_179,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
            TransactionEntity(
                id: "f834135d-8020-418d-b6aa-8c41bbf44f4e",
                timestamp: 1_709_372_189,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
        ]
    }

    static let transfer = TransactionEntity(
        id: "4b295da6-e8fd-43a7-b1c9-c7103a15abb0",
        timestamp: 1_709_372_124,
        sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
        destinationFundId: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
        amount: 100_000,
        type: "inout",
        userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
        currency: "VND"
    )

    static let spend = TransactionEntity(
        id: "86df35dd-be8a-4b10-bd8d-cfdac2b4c238",
        timestamp: 1_709_372_124,
        sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
        amount: 100_000,
        type: "inout",
        userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
        currency: "VND"
    )
}

// swiftlint:enable type_body_length
