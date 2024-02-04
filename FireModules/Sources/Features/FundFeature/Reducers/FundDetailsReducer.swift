//
//  FundDetailsReducer.swift
//
//
//  Created by Hien Tran on 15/01/2024.
//

import ComposableArchitecture
import Foundation
import FundsService
import RecordTransactionFeature

@Reducer
public struct FundDetailsReducer {
    public init() {}

    let fundService = FundsService()

    public struct State: Equatable, Identifiable {
        public init(fund: CreateFundResponse) {
            self.fund = fund
        }

        public var id: String {
            return fund.id
        }

        @PresentationState public var destination: Destination.State?
        public var fund: CreateFundResponse
        var fundDetailsLoadingState: NetworkLoadingState<CreateFundResponse> = .idle
        var fundDeletionState: NetworkLoadingState<DeleteFundResponse> = .idle
        var transactionsLoadingState: NetworkLoadingState<PaginationEntity<TransactionEntity>> = .idle
        var transactions: IdentifiedArrayOf<TransactionEntity> = []
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)

        public enum Delegate {
            case deleteFundButtonTapped
            case sendMoneyButtonTapped
            case onApear
        }

        public enum Forward {
            case loadFundDetailsSuccesfully(CreateFundResponse)
            case failedToLoadFundDetails(NetworkError)
            case deleteFundSuccesfully(DeleteFundResponse)
            case failedToDeleteFund(NetworkError)
            case loadFundDetails
            case loadTransactionHistory
            case loadTransactionsSuccesfully(PaginationEntity<TransactionEntity>)
            case loadTransactionsFailure(NetworkError)
            case fundDetailsUpdated(CreateFundResponse)
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.continuousClock) var clock
    @Dependency(\.fundsSerivce) var fundsService

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate(.onApear):
                guard state.transactionsLoadingState == .idle else { return .none }
                return .send(.forward(.loadTransactionHistory))
            case .delegate(.deleteFundButtonTapped):
                state.fundDeletionState = .loading
                return .run { [fundId = state.fund.id] send in
                    do {
                        let res = try await fundService.deleteFund(fundId: fundId)
                        await send(.forward(.deleteFundSuccesfully(res)))
                    } catch let error as NetworkError {
                        await send(.forward(.failedToDeleteFund(error)))
                    } catch {
                        await send(.forward(.failedToDeleteFund(NetworkError.unknown(error))))
                    }
                }
            case .delegate(.sendMoneyButtonTapped):
                state.destination = .sendMoney(.init(sourceFund: state.fund.asFundEntity()))
                return .none
            case .forward(.loadFundDetails):
                guard state.fundDetailsLoadingState != .loading else { return .none }
                state.fundDetailsLoadingState = .loading

                return .run { [fundId = state.fund.id] send in
                    do {
                        let res = try await fundService.getFundDetails(fundId: fundId)
                        await send(.forward(.loadFundDetailsSuccesfully(res)))
                    } catch let error as NetworkError {
                        await send(.forward(.failedToLoadFundDetails(error)))
                    } catch {
                        await send(.forward(.failedToLoadFundDetails(NetworkError.unknown(error))))
                    }
                }
            case .forward(.loadTransactionHistory):
                guard state.transactionsLoadingState != .loading else { return .none }
                state.transactionsLoadingState = .loading

                return .run { [fundId = state.fund.id] send in
                    do {
                        let res = try await fundService.getTransactions(fundId: fundId)
                        await send(.forward(.loadTransactionsSuccesfully(res)))
                    } catch let error as NetworkError {
                        await send(.forward(.loadTransactionsFailure(error)))
                    } catch {
                        await send(.forward(.loadTransactionsFailure(NetworkError.unknown(error))))
                    }
                }
            case let .forward(.loadTransactionsSuccesfully(pagination)):
                state.transactionsLoadingState = .loaded(pagination)
                state.transactions.append(contentsOf: pagination.items)
                return .none
            case let .forward(.loadTransactionsFailure(error)):
                state.transactionsLoadingState = .failure(error)
                return .none
            case let .forward(.fundDetailsUpdated(newValue)):
                state.fund = newValue
                return .none.animation()
            case let .forward(.loadFundDetailsSuccesfully(response)):
                state.fundDetailsLoadingState = .loaded(response)
                return .send(.forward(.fundDetailsUpdated(response)))
            case let .forward(.failedToLoadFundDetails(err)):
                state.fundDetailsLoadingState = .failure(err)
                return .none
            case let .forward(.deleteFundSuccesfully(response)):
                state.fundDeletionState = .loaded(response)
                return .run { _ in await dismiss() }
            case let .forward(.failedToDeleteFund(err)):
                state.fundDeletionState = .failure(err)
                return .none
            case let .destination(.presented(.sendMoney(.transactionRecordedSuccessfully(addedTransaction)))):
                state.transactions.insert(
                    TransactionEntity(
                        id: addedTransaction.id.uuidString,
                        timestamp: addedTransaction.timestamp,
                        sourceFundId: addedTransaction.sourceFundId.uuidString,
                        destinationFundId: addedTransaction.destinationFundId?.uuidString,
                        amount: addedTransaction.amount,
                        type: "out",
                        userId: addedTransaction.userId.uuidString,
                        currency: addedTransaction.currency,
                        description: addedTransaction.description
                    ),
                    at: 0
                )

                return .run { send in
                    try await clock.sleep(for: .milliseconds(1000))
                    await send(.forward(.loadFundDetails))
                }
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
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
                SendMoneyReducer()
            }
        }
    }
}
