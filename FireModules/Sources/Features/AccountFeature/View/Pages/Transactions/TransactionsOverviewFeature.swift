import ComposableArchitecture
import SwiftUI

@Reducer
public struct TransactionsOverviewFeature {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    public init() {}

    public var reducer: some ReducerOf<Self> {
        EmptyReducer()
    }
}
