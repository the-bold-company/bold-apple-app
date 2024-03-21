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
import InvestmentFeature
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

        @CasePathable
        public enum Forward {
            case refresh
            case fundRowTapped(FundEntity)
            case createFundButtonTapped
            case loadPortfolio
            case loadFundList
            case loadTransactionHistory
            case goToInvestmentPortfolio
        }

        @CasePathable
        public enum Delegate {
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
            case .forward(.loadPortfolio):
                return loadPortfolio(state: &state)
            case .forward(.loadFundList):
                return loadFundList(state: &state)
            case .forward(.loadTransactionHistory):
                return loadTransactionHistory(state: &state)
            case let .forward(.fundRowTapped(fund)):
                guard let fund = state.fundList[id: fund.id] else { return .none }
                state.destination = .fundDetailsRoute(.init(fund: fund))
                return .none
            case .forward(.createFundButtonTapped):
                state.destination = .fundCreationRoute(.init())
                return .none
            case .forward(.goToInvestmentPortfolio):
                state.destination = .investmentHomeRoute(.init())
                return .none
            case .forward(.refresh):
                return .none
            case let .delegate(.loadPortfolioSuccessfully(networth)):
                state.networthLoadingState = .loaded(networth)
                return .none
            case let .delegate(.loadPortfolioFailure(error)):
                state.networthLoadingState = .failure(error)
                return .none
            case let .delegate(.loadFundListSuccessfully(list)):
                state.fundLoadingState = .loaded(list)
                state.fundList = IdentifiedArray(uniqueElements: list)
                return .none
            case let .delegate(.loadFundListFailure(error)):
                state.fundLoadingState = .failure(error)
                return .none
            case let .delegate(.loadTransactionsSuccessfully(transactions)):
                let mostRecentFiveTransactions = Array(transactions.prefix(3))
                state.transactionLoadingState = .loaded(mostRecentFiveTransactions)
                state.transactionList = IdentifiedArray(uniqueElements: mostRecentFiveTransactions)
                return .none
            case let .delegate(.loadTransactionsFailed(error)):
                state.transactionLoadingState = .failure(error)
                return .none
            case let .delegate(.updateFund(updatedFund)):
                return updateFund(updatedFund, state: &state)
            case .destination(.presented(.fundDetailsRoute(.delegate(.deleteFundSuccesfully)))):
                guard let destination = state.destination,
                      case let .fundDetailsRoute(st) = destination
                else { return .none }
                state.fundList.remove(id: st.id)
                return .none
            case let .destination(.presented(.fundDetailsRoute(.delegate(.loadFundDetailsSuccesfully(updatedFund))))):
                return updateFund(updatedFund, state: &state)
            case let .destination(.presented(.fundDetailsRoute(.destination(.presented(.sendMoney(.delegate(.transactionRecordedSuccessfully(transaction)))))))):
                return .merge(
                    loadPortfolio(state: &state),
                    loadTransactionHistory(state: &state),
                    loadFundDetails(fundId: transaction.destinationFundId, state: &state)
                )
            case let .destination(.presented(.fundCreationRoute(.delegate(.fundCreatedSuccessfully(createdFund))))):
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

    private func updateFund(_ fund: FundEntity, state: inout State) -> Effect<Action> {
        state.fundList[id: fund.id] = fund
        return .none
    }

    private func loadFundDetails(fundId: UUID?, state _: inout State) -> Effect<Action> {
        guard let fundId else { return .none }
        return .run { send in
            try await clock.sleep(for: .milliseconds(1000))
            let loadDestinationFundResult = await fundDetailsUseCase.loadFundDetails(id: fundId)

            switch loadDestinationFundResult {
            case let .success(updatedDestinationFund):
                await send(.delegate(.updateFund(updatedDestinationFund)))
            case .failure:
                break
            }
        }
    }

    private func loadPortfolio(state: inout State) -> Effect<Action> {
        guard state.networthLoadingState != .loading else { return .none }

        state.networthLoadingState = .loading

        return .run { send in
            let networthResponse = await portfolioUseCase.getNetworth()

            switch networthResponse {
            case let .success(networth):
                await send(.delegate(.loadPortfolioSuccessfully(networth)))
            case .failure:
                break
            }
        }
    }

    private func loadFundList(state: inout State) -> Effect<Action> {
        guard state.fundLoadingState != .loading else { return .none }

        state.fundLoadingState = .loading

        return .run { send in
            let fundListResponse = await fundListUseCase.getFiatFundList()

            switch fundListResponse {
            case let .success(fundList):
                await send(.delegate(.loadFundListSuccessfully(fundList)))
            case .failure:
                break
            }
        }
    }

    private func loadTransactionHistory(state: inout State) -> Effect<Action> {
        guard state.transactionLoadingState != .loading else { return .none }

        state.transactionLoadingState = .loading

        return .run { send in
            let transactionListResponse = await transactionListUseCase.getInOutTransactions()

            switch transactionListResponse {
            case let .success(transactionList):
                await send(.delegate(.loadTransactionsSuccessfully(transactionList)))
            case .failure:
                break
            }
        }
    }
}

public extension HomeReducer {
    @Reducer
    struct Destination {
        public enum State: Equatable {
            case fundCreationRoute(FundCreationReducer.State)
            case fundDetailsRoute(FundDetailsReducer.State)
            case investmentHomeRoute(InvestmentHomeReducer.State)
        }

        public enum Action {
            case fundCreationRoute(FundCreationReducer.Action)
            case fundDetailsRoute(FundDetailsReducer.Action)
            case investmentHomeRoute(InvestmentHomeReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.fundCreationRoute, action: \.fundCreationRoute) {
                resolve(\FundFeatureContainer.fundCreationReducer)
            }

            Scope(state: \.fundDetailsRoute, action: \.fundDetailsRoute) {
                resolve(\FundFeatureContainer.fundDetailsReducer)
            }

            Scope(state: \.investmentHomeRoute, action: \.investmentHomeRoute) {
                resolve(\InvestmentFeatureContainer.investmentHomeReducer)?._printChanges()
            }
        }
    }
}
