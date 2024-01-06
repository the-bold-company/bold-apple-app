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

    public init() {}

    public struct State: Equatable {
        public init() {}

        var isLoading = false
        var networth: NetworthResponse?
        var networthError: String?
    }

    public enum Action: BindableAction {
        case onAppear
        case loadPortfolioSuccessfully(NetworthResponse)
        case loadPortfolioFailure(NetworkError)
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
                state.isLoading = true

                return .run { send in
                    do {
                        let res = try await portolioService.getNetworth()
                        await send(.loadPortfolioSuccessfully(res))
                    } catch let error as NetworkError {
                        await send(.loadPortfolioFailure(error))
                    } catch {
                        await send(.loadPortfolioFailure(.unknown(error)))
                    }
                }
            case .delegate:
                fatalError()
            case .navigate:
                fatalError()
            case let .loadPortfolioSuccessfully(networth):
                state.isLoading = false
                state.networth = networth
                return .none
            case let .loadPortfolioFailure(error):
                state.isLoading = true
                state.networthError = error.errorDescription
                return .none
            case .binding:
                return .none
            }
        }
    }
}
