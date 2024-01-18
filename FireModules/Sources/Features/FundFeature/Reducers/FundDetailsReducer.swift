//
//  FundDetailsReducer.swift
//
//
//  Created by Hien Tran on 15/01/2024.
//

import ComposableArchitecture
import Networking

@Reducer
public struct FundDetailsReducer {
    public init() {}

    let fundService = FundsService()

    public struct State: Equatable {
        public init(fund: CreateFundResponse) {
            self.fund = fund
        }

        let fund: CreateFundResponse
        var fundDetailsLoadingState: NetworkLoadingState<CreateFundResponse> = .idle
        var fundDeletionState: NetworkLoadingState<DeleteFundResponse> = .idle
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case navigate(Route)
        case binding(BindingAction<State>)

        case loadFundDetailsSuccesfully(CreateFundResponse)
        case failedToLoadFundDetails(NetworkError)
        case deleteFundSuccesfully(DeleteFundResponse)
        case failedToDeleteFund(NetworkError)

        public enum Route {
            case dismiss
        }

        public enum Delegate {
            case deleteFundButtonTapped
            case onApear
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate(.onApear):
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
            case let .loadFundDetailsSuccesfully(response):
                state.fundDetailsLoadingState = .loaded(response)
                return .none
            case let .failedToLoadFundDetails(err):
                state.fundDetailsLoadingState = .failure(err)
                return .none
            case let .deleteFundSuccesfully(response):
                state.fundDeletionState = .loaded(response)
                return .send(.navigate(.dismiss))
            case let .failedToDeleteFund(err):
                state.fundDeletionState = .failure(err)
                return .none
            case .binding, .delegate, .navigate:
                return .none
            }
        }
    }
}
