import ComposableArchitecture
import SwiftUI
import TCAExtensions

@Reducer
public struct TransactionsOverviewFeature {
    @Reducer(state: .equatable)
    public enum Destination {
        case createNewTransaction(TransactionCreationFeature)
    }

    public struct State: Equatable {
        @PresentationState var destination: Destination.State?
        public init() {}
    }

    public enum Action: FeatureAction, BindableAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)

        @CasePathable
        public enum ViewAction {
            case addTransactionButtonTapped
        }

        @CasePathable
        public enum DelegateAction {}

        @CasePathable
        public enum LocalAction {}
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case .delegate:
                return .none
            case ._local:
                return .none
            case .destination:
                return .none
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .addTransactionButtonTapped:
            state.destination = .createNewTransaction(.init())
            return .none
        }
    }
}
