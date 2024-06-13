import ComposableArchitecture
import TCACoordinators

public protocol FeatureAction {
    associatedtype ViewAction
    associatedtype DelegateAction
    associatedtype LocalAction

    static func view(_: ViewAction) -> Self
    static func delegate(_: DelegateAction) -> Self
    static func _local(_: LocalAction) -> Self
}

public extension Scope where ParentAction: FeatureAction {
    @inlinable
    init(
        toChildState: WritableKeyPath<ParentState, Child.State>,
        toChildAction: CasePath<ParentAction.LocalAction, Child.Action>,
        @ReducerBuilder<Child.State, Child.Action> child: () -> Child
    ) {
        self = .init(state: toChildState, action: (/ParentAction._local) .. toChildAction, child: child)
    }
}

public extension Store where Action: FeatureAction {
    func scope<ChildState, ChildAction>(
        state toChildState: @escaping (State) -> ChildState,
        action fromChildAction: AnyCasePath<Action.LocalAction, ChildAction>
    ) -> Store<ChildState, ChildAction> {
        scope(
            state: toChildState,
            action: { ._local(fromChildAction.embed($0)) }
        )
    }
}

public extension Reducer where State: IndexedRouterState, Action: FeatureAction, Action.LocalAction: IndexedRouterAction, State.Screen == Action.LocalAction.Screen {
    func forEachLocalRoute<ScreenReducer: Reducer, ScreenState, ScreenAction>(
        cancellationIdType: Any.Type = Self.self,
        @ReducerBuilder<ScreenReducer.State, ScreenAction> screenReducer: () -> ScreenReducer
    ) -> some ReducerOf<Self>
        where State.Screen == ScreenReducer.State,
        ScreenReducer.Action == Action.LocalAction.ScreenAction,
        ScreenState == ScreenReducer.State,
        ScreenAction == ScreenReducer.Action
    {
        forEachRoute(
            coordinatorIdForCancellation: ObjectIdentifier(Self.self),
            toLocalState: \.routes,
            toLocalAction: /Action._local .. /Action.LocalAction.routeAction,
            updateRoutes: /Action._local .. /Action.LocalAction.updateRoutes,
            screenReducer: screenReducer
        )
    }
}
