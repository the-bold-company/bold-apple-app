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

        var loadingState: NetworkLoadingState<CreateFundResponse> = .idle
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case binding(BindingAction<State>)

        case fundCreatedSuccessfully(CreateFundResponse)
        case failedToCreateFund(NetworkError)

        public enum Delegate {
            case submitButtonTapped
        }
    }

    @Dependency(\.dismiss) var dismiss

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
                return .run { _ in await dismiss() }
            case let .failedToCreateFund(err):
                state.loadingState = .failure(err)
                return .none
            }
        }
    }
}
