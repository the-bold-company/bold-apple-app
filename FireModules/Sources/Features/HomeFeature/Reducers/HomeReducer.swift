//
//  HomeReducer.swift
//
//
//  Created by Hien Tran on 07/01/2024.
//

import ComposableArchitecture
import DomainEntities
import Factory
import Foundation
import FundDetailsUseCase
import FundFeature
import FundListUseCase
import PortfolioUseCase
import TransactionListUseCase

@Reducer
public struct HomeReducer {
    public struct State: Equatable {
        public init(destination: Destination.State? = nil) {
            self.destination = destination
        }

        @PresentationState public var destination: Destination.State?

        var networthLoadingState: LoadingState<NetworthEntity> = .idle
        var fundLoadingState: LoadingState<[FundEntity]> = .idle
        var transactionLoadingState: LoadingState<[TransactionEntity]> = .idle

        var fundList: IdentifiedArrayOf<FundEntity> = []
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
            case fundRowTapped(FundEntity)
            case createFundButtonTapped
        }

        public enum Forward {
            case loadPortfolioSuccessfully(NetworthEntity)
            case loadPortfolioFailure(DomainError)
            case loadFundListSuccessfully([FundEntity])
            case loadFundListFailure(DomainError)
            case loadTransactionsSuccessfully([TransactionEntity])
            case loadTransactionsFailed(DomainError)
            case updateFund(FundEntity)
        }
    }

    @Dependency(\.continuousClock) var clock

    let transactionListUseCase: TransactionListUseCaseProtocol
    let fundListUseCase: FundListUseCaseProtocol
    let fundDetailsUseCase: FundDetailsUseCaseProtocol
    let portfolioUseCase: PortfolioUseCaseInterface

    public init(
        transactionListUseCase: TransactionListUseCaseProtocol,
        fundListUseCase: FundListUseCaseProtocol,
        fundDetailsUseCase: FundDetailsUseCaseProtocol,
        portfolioUseCase: PortfolioUseCaseInterface
    ) {
        self.transactionListUseCase = transactionListUseCase
        self.fundListUseCase = fundListUseCase
        self.fundDetailsUseCase = fundDetailsUseCase
        self.portfolioUseCase = portfolioUseCase
    }

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
                    async let networthResponse = portfolioUseCase.getNetworth()
                    async let fundListResponse = fundListUseCase.getFiatFundList()
                    async let transactionListResponse = transactionListUseCase.getInOutTransactions()

                    switch await networthResponse {
                    case let .success(networth):
                        await send(.forward(.loadPortfolioSuccessfully(networth)))
                    case .failure:
                        break
                    }

                    switch await fundListResponse {
                    case let .success(fundList):
                        await send(.forward(.loadFundListSuccessfully(fundList)))
                    case .failure:
                        break
                    }

                    switch await transactionListResponse {
                    case let .success(transactionList):
                        await send(.forward(.loadTransactionsSuccessfully(transactionList)))
                    case .failure:
                        break
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
                state.fundLoadingState = .loaded(list)
                state.fundList = IdentifiedArray(uniqueElements: list)
                return .none
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
                    async let networthResponse = portfolioUseCase.getNetworth()
                    async let loadTransactionsResult = transactionListUseCase.getInOutTransactions()

                    if let destinationFundId = transaction.destinationFundId {
                        try await clock.sleep(for: .milliseconds(1000))
                        async let loadDestinationFundResult = fundDetailsUseCase.loadFundDetails(id: destinationFundId)

                        switch await loadDestinationFundResult {
                        case let .success(updatedDestinationFund):
                            await send(.forward(.updateFund(updatedDestinationFund)))
                        case .failure:
                            break
                        }
                    }

                    switch await networthResponse {
                    case let .success(networth):
                        await send(.forward(.loadPortfolioSuccessfully(networth)))
                    case .failure:
                        break
                    }

                    switch await loadTransactionsResult {
                    case let .success(transactions):
                        await send(.forward(.loadTransactionsSuccessfully(transactions)))
                    case .failure:
                        break
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
                resolve(\FundFeatureContainer.fundCreationReducer)
            }

            Scope(state: \.fundDetailsRoute, action: \.fundDetailsRoute) {
                resolve(\FundFeatureContainer.fundDetailsReducer)
            }
        }
    }
}
