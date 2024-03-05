//
//  FundDetailsReducer.swift
//
//
//  Created by Hien Tran on 15/01/2024.
//

import ComposableArchitecture
import Foundation
import RecordTransactionFeature

import Factory
import FundDetailsUseCase

@Reducer
public struct FundDetailsReducer {
    public struct State: Equatable, Identifiable {
        public init(fund: FundEntity) {
            self.fund = fund
        }

        public var id: UUID {
            return fund.id
        }

        @PresentationState public var destination: Destination.State?
        public var fund: FundEntity
        var fundDetailsLoadingState: LoadingState<FundEntity> = .idle
        var fundDeletionState: LoadingState<UUID> = .idle
        var transactionsLoadingState: LoadingState<PaginationEntity<TransactionEntity>> = .idle
        var transactions: IdentifiedArrayOf<TransactionEntity> = []
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)

        @CasePathable
        public enum Forward {
            case deleteFundButtonTapped
            case sendMoneyButtonTapped
            case loadFundDetails
            case loadTransactionHistory
        }

        @CasePathable
        public enum Delegate {
            case loadFundDetailsSuccesfully(FundEntity)
            case failedToLoadFundDetails(DomainError)
            case deleteFundSuccesfully(UUID)
            case failedToDeleteFund(DomainError)
            case loadTransactionsSuccesfully(PaginationEntity<TransactionEntity>)
            case loadTransactionsFailure(DomainError)
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.continuousClock) var clock

    let fundDetailsUseCase: FundDetailsUseCaseProtocol

    public init(fundDetailsUseCase: FundDetailsUseCaseProtocol) {
        self.fundDetailsUseCase = fundDetailsUseCase
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .forward(.deleteFundButtonTapped):
                return deleteFund(state: &state)
            case .forward(.sendMoneyButtonTapped):
                state.destination = .sendMoney(.init(sourceFund: state.fund))
                return .none
            case .forward(.loadFundDetails):
                return loadFundDetails(state: &state)
            case .forward(.loadTransactionHistory):
                return loadTransactionHistory(state: &state)
            case let .delegate(.loadTransactionsSuccesfully(pagination)):
                state.transactionsLoadingState = .loaded(pagination)
                state.transactions.append(contentsOf: pagination.items)
                return .none
            case let .delegate(.loadTransactionsFailure(error)):
                state.transactionsLoadingState = .failure(error)
                return .none
            case let .delegate(.loadFundDetailsSuccesfully(response)):
                state.fundDetailsLoadingState = .loaded(response)
                state.fund = response
                return .none.animation()
            case let .delegate(.failedToLoadFundDetails(err)):
                state.fundDetailsLoadingState = .failure(err)
                return .none
            case let .delegate(.deleteFundSuccesfully(response)):
                state.fundDeletionState = .loaded(response)
                return .run { _ in await dismiss() }
            case let .delegate(.failedToDeleteFund(err)):
                state.fundDeletionState = .failure(err)
                return .none
            case let .destination(.presented(.sendMoney(.transactionRecordedSuccessfully(addedTransaction)))):
                state.transactions.insert(addedTransaction, at: 0)

                return loadFundDetails(state: &state)
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }

    private func loadTransactionHistory(state: inout State) -> Effect<Action> {
        guard state.transactionsLoadingState != .loading else { return .none }
        state.transactionsLoadingState = .loading

        return .run { [fundId = state.fund.id] send in
            let result = await fundDetailsUseCase.loadTransactionHistory(fundId: fundId, order: .descending)
            switch result {
            case let .success(pagination):
                await send(.delegate(.loadTransactionsSuccesfully(pagination)))
            case let .failure(error):
                await send(.delegate(.loadTransactionsFailure(error)))
            }
        }
    }

    private func loadFundDetails(state: inout State) -> Effect<Action> {
        guard state.fundDetailsLoadingState != .loading else { return .none }
        state.fundDetailsLoadingState = .loading

        return .run { [fundId = state.fund.id] send in
            let result = await fundDetailsUseCase.loadFundDetails(id: fundId)

            switch result {
            case let .success(details):
                await send(.delegate(.loadFundDetailsSuccesfully(details)))
            case let .failure(error):
                await send(.delegate(.failedToLoadFundDetails(error)))
            }
        }
    }

    private func deleteFund(state: inout State) -> Effect<Action> {
        guard state.fundDeletionState != .loading else { return .none }

        state.fundDeletionState = .loading

        return .run { [fundId = state.fund.id] send in
            let result = await fundDetailsUseCase.deleteFund(id: fundId)
            switch result {
            case let .success(id):
                await send(.delegate(.deleteFundSuccesfully(id)))
            case let .failure(error):
                await send(.delegate(.failedToDeleteFund(error)))
            }
        }
    }
}

public extension FundDetailsReducer {
    @Reducer
    struct Destination {
        public enum State: Equatable {
            case sendMoney(SendMoneyReducer.State)
        }

        public enum Action {
            case sendMoney(SendMoneyReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.sendMoney, action: \.sendMoney) {
                resolve(\RecordTransactionFeatureContainer.sendMoneyReducer)
            }
        }
    }
}
