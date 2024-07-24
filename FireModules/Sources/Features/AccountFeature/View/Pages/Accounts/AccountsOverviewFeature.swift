import ComposableArchitecture
import SwiftUI

@Reducer
public struct AccountsOverviewFeature {
    public struct State: Equatable {}
    public enum Action {}
    public var reducer: some ReducerOf<Self> {
        EmptyReducer()
    }
}
