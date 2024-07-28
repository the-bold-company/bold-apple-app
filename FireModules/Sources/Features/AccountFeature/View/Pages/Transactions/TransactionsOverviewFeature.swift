import ComposableArchitecture
import SwiftUI

@Reducer
public struct TransactionsOverviewFeature {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {}
    public init() {}
    public var reducer: some ReducerOf<Self> {
        EmptyReducer()
    }
}
