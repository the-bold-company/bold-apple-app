import ComposableArchitecture
import CoreUI
import SwiftUI
import TCAExtensions

@Reducer
public struct HomeFeature {
    @Reducer(state: .equatable)
    public enum Destination {
        case overview(OverviewFeature)
        case reports(ReportFeature)
        case accounts(AccountsFeature)
        case transactions(TransactionsFeature)
        case categories(CategoriesFeature)
    }

    public struct State: Equatable {
        @PresentationState var destination: Destination.State? = .overview(.init())
        public init() {}

        var something: String = ""
    }

    public enum Action: BindableAction {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
//        case delegate(DelegateAction)
//        case _local(LocalAction)
        case view(ViewAction)

//        @CasePathable
//        public enum LocalAction {}
//
//        @CasePathable
//        public enum DelegateAction {}

        @CasePathable
        public enum ViewAction {
            case goToOverview
            case goToReports
            case goToAccounts
            case goToTransactions
            case goToCategories
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case .destination, .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .goToOverview:
            state.destination = .overview(.init())
        case .goToReports:
            state.destination = .reports(.init())
        case .goToAccounts:
            state.destination = .accounts(.init())
        case .goToTransactions:
            state.destination = .transactions(.init())
        case .goToCategories:
            state.destination = .categories(.init())
        }
        return .none
    }
}
