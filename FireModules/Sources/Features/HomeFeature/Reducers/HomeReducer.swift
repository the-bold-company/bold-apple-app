//
//  HomeReducer.swift
//
//
//  Created by Hien Tran on 07/01/2024.
//

import ComposableArchitecture
import Networking

@Reducer
public struct HomeReducer {
    let portolioService = PortfolioAPIService()
    let fundsService = FundsService()

    public init() {}

    public struct State: Equatable {
        public init() {}

        var isLoadingNetworth = false
        var networth: NetworthResponse?
        var networthError: String?

        var isLoadingFunds = false
        var funds: [CreateFundResponse] = []
        var fundsError: String?
    }

    public enum Action: BindableAction {
        case onAppear
        case loadPortfolioSuccessfully(NetworthResponse)
        case loadPortfolioFailure(NetworkError)
        case loadFundListSuccessfully(FundListResponse)
        case loadFundListFailure(NetworkError)
        case binding(BindingAction<State>)

        case navigate(Route)
        case delegate(Delegate)

        public enum Route {
            case settingsRoute
        }

        public enum Delegate {
            case refresh
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoadingNetworth = true
                state.isLoadingFunds = true

                return .run { send in
                    do {
                        async let networthResponse = try portolioService.getNetworth()
                        async let fundListResponse = try fundsService.listFunds()

                        try await send(.loadPortfolioSuccessfully(networthResponse))
                        try await send(.loadFundListSuccessfully(fundListResponse))
                    } catch let error as NetworkError {
                        print("network error: \(error)")
                        await send(.loadPortfolioFailure(error))
                    } catch {
                        print("error: \(error)")
                        await send(.loadPortfolioFailure(.unknown(error)))
                    }
                }
            case .delegate:
                fatalError()
            case .navigate:
                fatalError()
            case let .loadPortfolioSuccessfully(networth):
                state.isLoadingNetworth = false
                state.networth = networth
                return .none
            case let .loadPortfolioFailure(error):
                state.isLoadingNetworth = false
                state.networthError = error.errorDescription
                return .none
            case let .loadFundListSuccessfully(list):
                state.isLoadingFunds = false
                state.funds = list.funds
                return .none
            case let .loadFundListFailure(error):
                state.isLoadingFunds = false
                state.fundsError = error.errorDescription
                return .none
            case .binding:
                return .none
            }
        }
    }
}
