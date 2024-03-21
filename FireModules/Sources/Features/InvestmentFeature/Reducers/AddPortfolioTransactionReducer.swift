import ComposableArchitecture
import SwiftUI

@Reducer
public struct AddPortfolioTransactionReducer {
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

public extension AddPortfolioTransactionReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {}

        public enum Action {}

        public var body: some ReducerOf<Self> {
            Reduce { _, _ in
                return .none
            }
        }
    }
}
