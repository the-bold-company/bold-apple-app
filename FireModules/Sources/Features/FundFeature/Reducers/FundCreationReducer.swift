//
//  FundCreationReducer.swift
//
//
//  Created by Hien Tran on 14/01/2024.
//

import ComposableArchitecture
import Foundation
import Networking

@Reducer
public struct FundCreationReducer {
    public init() {}

    let fundsService = FundsService()

    public struct State: Equatable {
        public init(
            fundName: String = "",
            description: String = "",
            balance: Int = 0
        ) {
            self.fundName = fundName
            self.description = description
            self.balance = balance
        }

        @BindingState public var fundName: String
        @BindingState public var description: String
        @BindingState public var balance: Int

        var loadingState: LoadingState<CreateFundResponse, NetworkError> = .idle
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case binding(BindingAction<State>)
        case navigate(Route)

        case fundCreatedSuccessfully(CreateFundResponse)
        case failedToCreateFund(NetworkError)

        public enum Route {
            case dismissFundCreation
        }

        public enum Delegate {
            case submitButtonTapped
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .delegate(.submitButtonTapped):
                state.loadingState = .loading

                return .run { [name = state.fundName, description = state.description, balance = state.balance] send in
                    do {
                        let res = try await fundsService.createFund(
                            name: name,
                            balance: Decimal(balance),
                            fundType: .fiat, // TODO: Hardcode this for now
                            currency: "VND",
                            description: description.isEmpty ? nil : description
                        )

                        await send(.fundCreatedSuccessfully(res))
                    } catch let error as NetworkError {
                        await send(.failedToCreateFund(error))
                    } catch {
                        await send(.failedToCreateFund(NetworkError.unknown(error)))
                    }
                }
            case let .fundCreatedSuccessfully(response):
                state.loadingState = .loaded(response)
                return .send(.navigate(.dismissFundCreation))
            case let .failedToCreateFund(err):
                state.loadingState = .failure(err)
                return .none
            case .navigate:
                return .none
            }
        }
    }
}

public enum LoadingState<Success, Failure>: Equatable where Success: Equatable, Failure: Error {
    case idle
    case loading
    case loaded(Success)
    case failure(Failure)

    public static func == (lhs: LoadingState<Success, Failure>, rhs: LoadingState<Success, Failure>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case let (.loaded(lhsResult), .loaded(rhsResult)):
            return lhsResult == rhsResult
        case let (.failure(lhsErr), failure(rhsErr)):
            return lhsErr.localizedDescription == rhsErr.localizedDescription
        default:
            return false
        }
    }

    public var isLoading: Bool {
        return self == .loading
    }
}
