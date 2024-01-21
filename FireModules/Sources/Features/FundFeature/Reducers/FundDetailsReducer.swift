//
//  FundDetailsReducer.swift
//
//
//  Created by Hien Tran on 15/01/2024.
//

import ComposableArchitecture
import Foundation
import Networking
import RecordTransactionFeature

@Reducer
public struct FundDetailsReducer {
    public init() {}

    let fundService = FundsService()

    public struct State: Equatable, Identifiable {
        public init(
            fund: CreateFundResponse,
            destination: Destination.State? = nil
        ) {
            self.fund = fund
            self.destination = destination
        }

        public var id: String {
            return fund.id
        }

        @PresentationState public var destination: Destination.State?
        public let fund: CreateFundResponse
        var fundDetailsLoadingState: NetworkLoadingState<CreateFundResponse> = .idle
        var fundDeletionState: NetworkLoadingState<DeleteFundResponse> = .idle
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)

        case loadFundDetailsSuccesfully(CreateFundResponse)
        case failedToLoadFundDetails(NetworkError)
        case deleteFundSuccesfully(DeleteFundResponse)
        case failedToDeleteFund(NetworkError)

        public enum Delegate {
            case deleteFundButtonTapped
            case sendMoneyButtonTapped
            case onApear
        }
    }

    @Dependency(\.dismiss) var dismiss

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding, .destination:
                return .none
            case .delegate(.onApear):
                guard state.fundDetailsLoadingState == .idle else { return .none }
                state.fundDetailsLoadingState = .loading

                return .run { [fundId = state.fund.id] send in
                    do {
                        let res = try await fundService.getFundDetails(fundId: fundId)
                        await send(.loadFundDetailsSuccesfully(res))
                    } catch let error as NetworkError {
                        await send(.failedToLoadFundDetails(error))
                    } catch {
                        await send(.failedToLoadFundDetails(NetworkError.unknown(error)))
                    }
                }
            case .delegate(.deleteFundButtonTapped):
                state.fundDeletionState = .loading
                return .run { [fundId = state.fund.id] send in
                    do {
                        let res = try await fundService.deleteFund(fundId: fundId)
                        await send(.deleteFundSuccesfully(res))
                    } catch let error as NetworkError {
                        await send(.failedToDeleteFund(error))
                    } catch {
                        await send(.failedToDeleteFund(NetworkError.unknown(error)))
                    }
                }
            case .delegate(.sendMoneyButtonTapped):
                state.destination = .sendMoney(.init(sourceFund: state.fund.asFundEntity()))
                return .none
            case let .loadFundDetailsSuccesfully(response):
                state.fundDetailsLoadingState = .loaded(response)
                return .none
            case let .failedToLoadFundDetails(err):
                state.fundDetailsLoadingState = .failure(err)
                return .none
            case let .deleteFundSuccesfully(response):
                state.fundDeletionState = .loaded(response)
                return .run { _ in await dismiss() }
            case let .failedToDeleteFund(err):
                state.fundDeletionState = .failure(err)
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
