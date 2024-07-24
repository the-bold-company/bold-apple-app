import ComposableArchitecture
import SwiftUI

@Reducer
public struct TransactionsOverviewFeature {
    public struct State: Equatable {}
    public enum Action {}
    public var reducer: some ReducerOf<Self> {
        EmptyReducer()
    }
}
