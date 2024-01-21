//
//  HomeReducer.swift
//
//
//  Created by Hien Tran on 07/01/2024.
//

import ComposableArchitecture
import Foundation
import FundFeature
import Networking
import SharedServices

@Reducer
public struct HomeReducer {
    let portolioService = PortfolioAPIService()
    let fundsService = FundsService()

    public init() {}

    public struct State: Equatable {
        public init(destination: Destination.State? = nil) {
            self.destination = destination
        }

        @PresentationState public var destination: Destination.State?

        var networthLoadingState: NetworkLoadingState<NetworthResponse> = .idle
        var fundLoadingState: NetworkLoadingState<[CreateFundResponse]> = .idle
        var fundList: IdentifiedArrayOf<FundDetailsReducer.State> = []
    }

    public enum Action: BindableAction {
        case onAppear
        case loadPortfolioSuccessfully(NetworthResponse)
        case loadPortfolioFailure(NetworkError)
        case loadFundListSuccessfully(FundListResponse)
        case loadFundListFailure(NetworkError)
        case binding(BindingAction<State>)
        case fundList(id: FundDetailsReducer.State.ID, action: FundDetailsReducer.Action)
        case destination(PresentationAction<Destination.Action>)

        case delegate(Delegate)

        public enum Delegate {
            case refresh
            case fundRowTapped(CreateFundResponse)
            case createFundButtonTapped
        }
    }

    @Dependency(\.authGuardService) var authGuardService

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.networthLoadingState == .idle,
                      state.fundLoadingState == .idle
                else { return .none }

                state.networthLoadingState = .loading
                state.fundLoadingState = .loading

                return .run { send in
                    do {
                        async let networthResponse = try portolioService.getNetworth()
                        async let fundListResponse = try fundsService.listFunds()

                        try await send(.loadPortfolioSuccessfully(networthResponse))
                        try await send(.loadFundListSuccessfully(fundListResponse))
                    } catch let error as NetworkError {
                        await send(.loadPortfolioFailure(error))
                    } catch {
                        await send(.loadPortfolioFailure(.unknown(error)))
                    }
                }
            case let .loadPortfolioSuccessfully(networth):
                state.networthLoadingState = .loaded(networth)
                return .none
            case let .loadPortfolioFailure(error):
                state.networthLoadingState = .failure(error)
                return .none
            case let .loadFundListSuccessfully(list):
                state.fundLoadingState = .loaded(list.funds)
                state.fundList = IdentifiedArray(
                    uniqueElements: list.funds.map {
                        FundDetailsReducer.State(fund: $0)
                    }
                )
                return .run { _ in
                    await authGuardService.updateLoadedFunds(list.funds.map { $0.asFundEntity() })
                }
            case let .loadFundListFailure(error):
                state.fundLoadingState = .failure(error)
                return .none
            case .binding:
                return .none
            case let .delegate(.fundRowTapped(fund)):
                guard let fundState = state.fundList[id: fund.id] else { return .none }
                state.destination = .fundDetailsRoute(fundState)
                return .none
            case .delegate(.createFundButtonTapped):
                state.destination = .fundCreationRoute(.init())
                return .none
            case .delegate(.refresh):
                return .none
            case .destination(.presented(.fundDetailsRoute(.deleteFundSuccesfully))):
                guard let destination = state.destination,
                      case let .fundDetailsRoute(st) = destination
                else { return .none }
                state.fundList.remove(id: st.id)
                return .none
            case let .destination(.presented(.fundCreationRoute(.fundCreatedSuccessfully(createdFund)))):
//                guard let destination = state.destination,
//                    case let .fundDetailsRoute(st) = destination
//                else { return .none }
                state.fundList.append(FundDetailsReducer.State(fund: createdFund))
                return .none
            case let .fundList(id: id, action: action):
                switch action {
                case .delegate(.deleteFundButtonTapped):
                    state.fundList.remove(id: id)
                    return .none
                default:
                    return .none
                }
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

public extension HomeReducer {
    @Reducer
    struct Destination {
        public enum State: Equatable {
            case fundCreationRoute(FundCreationReducer.State)
            case fundDetailsRoute(FundDetailsReducer.State)
        }

        public enum Action {
            case fundCreationRoute(FundCreationReducer.Action)
            case fundDetailsRoute(FundDetailsReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.fundCreationRoute, action: \.fundCreationRoute) {
                FundCreationReducer()
            }

            Scope(state: \.fundDetailsRoute, action: \.fundDetailsRoute) {
                FundDetailsReducer()
            }
        }
    }
}
