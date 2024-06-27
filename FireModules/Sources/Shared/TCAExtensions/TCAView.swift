import ComposableArchitecture
import SwiftUI

public protocol TCAView: View {
    associatedtype ReducerState
    associatedtype ReducerAction: FeatureAction
    associatedtype ViewState: Equatable

    var store: Store<ReducerState, ReducerAction> { get }
    var viewStore: ViewStore<ViewState, ReducerAction> { get }
}
