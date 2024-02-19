//
//  HomeReducer.swift
//
//
//  Created by Hien Tran on 07/01/2024.
//

import ComposableArchitecture
import Foundation
import FundFeature
import FundsService
import LoggedInUserService
import Networking
import PersistentService
import TransactionsService

@Reducer
public struct HomeReducer {
    let portolioService = PortfolioAPIService()

    public init() {}

    public struct State: Equatable {
        public init(destination: Destination.State? = nil) {
            self.destination = destination
        }

        @PresentationState public var destination: Destination.State?

        var networthLoadingState: NetworkLoadingState<NetworthResponse> = .idle
        var fundLoadingState: NetworkLoadingState<[CreateFundResponse]> = .idle
        var transactionLoadingState: NetworkLoadingState<[TransactionEntity]> = .idle

        var fundList: IdentifiedArrayOf<CreateFundResponse> = []
        var transactionList: IdentifiedArrayOf<TransactionEntity> = []
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        case delegate(Delegate)
        case forward(Forward)

        public enum Delegate {
            case onAppear
            case refresh
            case fundRowTapped(CreateFundResponse)
            case createFundButtonTapped
        }

        public enum Forward {
            case loadPortfolioSuccessfully(NetworthResponse)
            case loadPortfolioFailure(NetworkError)
            case loadFundListSuccessfully(FundListResponse)
            case loadFundListFailure(NetworkError)
            case loadTransactionsSuccessfully([TransactionEntity])
            case loadTransactionsFailed(NetworkError)
            case updateFund(CreateFundResponse)
        }
    }

    @Dependency(\.loggedInUserService) var loggedInUserService
    @Dependency(\.transactionSerivce) var transactionService
    @Dependency(\.continuousClock) var clock
    @Dependency(\.fundsSerivce) var fundsService
    @Dependency(\.persistentSerivce) var persistentSerivce

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate(.onAppear):
                guard state.networthLoadingState == .idle,
                      state.fundLoadingState == .idle,
                      state.transactionLoadingState == .idle
                else { return .none }

                state.networthLoadingState = .loading
                state.fundLoadingState = .loading
                state.transactionLoadingState = .loading

                return .run { send in
                    do {
                        async let networthResponse = try portolioService.getNetworth()
                        async let fundListResponse = try fundsService.listFunds()
                        async let transactionList = try transactionService.getTransactionLists()

                        try await send(.forward(.loadPortfolioSuccessfully(networthResponse)))
                        try await send(.forward(.loadFundListSuccessfully(fundListResponse)))
                        try await send(.forward(.loadTransactionsSuccessfully(transactionList)))
                    } catch let error as NetworkError {
                        await send(.forward(.loadPortfolioFailure(error)))
                    } catch {
                        print(error)
                        await send(.forward(.loadPortfolioFailure(.unknown(error))))
                    }
                }
            case let .delegate(.fundRowTapped(fund)):
                guard let fund = state.fundList[id: fund.id] else { return .none }
                state.destination = .fundDetailsRoute(.init(fund: fund))
                return .none
            case .delegate(.createFundButtonTapped):
                state.destination = .fundCreationRoute(.init())
                return .none
            case .delegate(.refresh):
                return .none
            case let .forward(.loadPortfolioSuccessfully(networth)):
                state.networthLoadingState = .loaded(networth)
                return .none
            case let .forward(.loadPortfolioFailure(error)):
                state.networthLoadingState = .failure(error)
                return .none
            case let .forward(.loadFundListSuccessfully(list)):
                state.fundLoadingState = .loaded(list.funds)
                state.fundList = IdentifiedArray(uniqueElements: list.funds)
                return .run { _ in
                    do {
                        await loggedInUserService.updateLoadedFunds(list.funds.map { $0.asFundEntity() })
                        try await persistentSerivce.saveFunds(list.funds.map { $0.asFundEntity() })
                    } catch {
                        // Do we have to handle this error?
                    }
                }
            case let .forward(.loadFundListFailure(error)):
                state.fundLoadingState = .failure(error)
                return .none
            case let .forward(.loadTransactionsSuccessfully(transactions)):
                let mostRecentFiveTransactions = Array(transactions.prefix(3))
                state.transactionLoadingState = .loaded(mostRecentFiveTransactions)
                state.transactionList = IdentifiedArray(uniqueElements: mostRecentFiveTransactions)
                return .none
            case let .forward(.loadTransactionsFailed(error)):
                state.transactionLoadingState = .failure(error)
                return .none
            case let .forward(.updateFund(updatedFund)):
                state.fundList[id: updatedFund.id] = updatedFund
                return .none
            case .destination(.presented(.fundDetailsRoute(.forward(.deleteFundSuccesfully)))):
                guard let destination = state.destination,
                      case let .fundDetailsRoute(st) = destination
                else { return .none }
                state.fundList.remove(id: st.id)
                return .none
            case let .destination(.presented(.fundDetailsRoute(.forward(.fundDetailsUpdated(updatedFund))))):
                return .send(.forward(.updateFund(updatedFund)))
            case let .destination(.presented(.fundDetailsRoute(.destination(.presented(.sendMoney(.transactionRecordedSuccessfully(transaction))))))):
                guard state.networthLoadingState != .loading,
                      state.transactionLoadingState != .loading
                else { return .none }

                state.networthLoadingState = .loading
                state.transactionLoadingState = .loading

                return .run { send in
                    do {
                        async let networthResponse = try portolioService.getNetworth()
                        async let transactionList = try transactionService.getTransactionLists()

                        if let destinationFundId = transaction.destinationFundId?.uuidString.lowercased() {
//                            try await clock.sleep(for: .milliseconds(500))
                            try await clock.sleep(for: .milliseconds(1000))
                            async let loadDestinationFund = try fundsService.getFundDetails(fundId: destinationFundId)
                            try await send(.forward(.updateFund(loadDestinationFund)))
                        }

                        try await send(.forward(.loadPortfolioSuccessfully(networthResponse)))
                        try await send(.forward(.loadTransactionsSuccessfully(transactionList)))
                    } catch {
                        // do nothing
                    }
                }
            case let .destination(.presented(.fundCreationRoute(.fundCreatedSuccessfully(createdFund)))):
                state.fundList.append(createdFund)
                return .none
            case .destination(.dismiss):
                return .none
            case .destination, .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

public extension HomeReducer {
    @Reducer
    struct Destination {
        public enum State: Equatable {
            case fundCreationRoute(FundCreationReducer.State)
            case fundDetailsRoute(FundDetailsReducer.State)
        }

        public enum Action {
            case fundCreationRoute(FundCreationReducer.Action)
            case fundDetailsRoute(FundDetailsReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.fundCreationRoute, action: \.fundCreationRoute) {
                FundCreationReducer()
            }

            Scope(state: \.fundDetailsRoute, action: \.fundDetailsRoute) {
                FundDetailsReducer()
            }
        }
    }
}
