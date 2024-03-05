//
//  FundCreationReducer.swift
//
//
//  Created by Hien Tran on 14/01/2024.
//

import ComposableArchitecture
import Foundation
import FundCreationUseCase

@Reducer
public struct FundCreationReducer {
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

        var loadingState: LoadingState<FundEntity> = .idle
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case binding(BindingAction<State>)

        @CasePathable
        public enum Delegate {
            case fundCreatedSuccessfully(FundEntity)
            case failedToCreateFund(DomainError)
        }

        @CasePathable
        public enum Forward {
            case submitButtonTapped
        }
    }

    @Dependency(\.dismiss) var dismiss

    let fundCreationUseCase: FundCreationUseCaseProtocol

    public init(fundCreationUseCase: FundCreationUseCaseProtocol) {
        self.fundCreationUseCase = fundCreationUseCase
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .forward(.submitButtonTapped):
                state.loadingState = .loading

                return .run { [name = state.fundName, description = state.description, balance = state.balance] send in

                    let result = await fundCreationUseCase.createFiatFund(
                        name: name,
                        balance: Decimal(balance),
                        currency: "VND",
                        description: description.isEmpty ? nil : description
                    )
                    switch result {
                    case let .success(createdFund):
                        await send(.delegate(.fundCreatedSuccessfully(createdFund)))
                    case let .failure(error):
                        await send(.delegate(.failedToCreateFund(error)))
                    }
                }
            case let .delegate(.fundCreatedSuccessfully(response)):
                state.loadingState = .loaded(response)
                return .run { _ in await dismiss() }
            case let .delegate(.failedToCreateFund(err)):
                state.loadingState = .failure(err)
                return .none
            }
        }
    }
}
