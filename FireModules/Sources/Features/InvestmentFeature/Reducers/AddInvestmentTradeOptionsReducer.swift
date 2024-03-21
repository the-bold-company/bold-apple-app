import ComposableArchitecture
import SwiftUI

@Reducer
public struct AddInvestmentTradeOptionsReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        public init() {}
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum Forward {
            case forward
        }

        @CasePathable
        public enum Delegate {
            case delegate
        }
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { _, action in
            switch action {
            case .delegate:
                return .none
            case .forward:
                return .none
            case .binding, .destination:
                return .none
            }
        }
    }
}

public extension AddInvestmentTradeOptionsReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case addTransactionRoute(AddPortfolioTransactionReducer.State)
        }

        public enum Action {
            case addTransactionRoute(AddPortfolioTransactionReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.addTransactionRoute, action: \.addTransactionRoute) {
                AddPortfolioTransactionReducer()
            }
        }
    }
}
