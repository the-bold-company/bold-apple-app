import ComposableArchitecture
import Foundation
import TCACoordinators

public protocol FeatureAction: ViewAction {
    associatedtype DelegateAction
    associatedtype LocalAction

    static func delegate(_: DelegateAction) -> Self
    static func _local(_: LocalAction) -> Self
}

public extension Scope where ParentAction: FeatureAction {
    @inlinable
    init(
        state toChildState: WritableKeyPath<ParentState, Child.State>,
        action toChildAction: AnyCasePath<ParentAction.LocalAction, Child.Action>,
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

public extension Effect where Action: FeatureAction, Action.LocalAction: IndexedRouterAction {
    /// Allows arbitrary changes to be made to the routes collection, even if SwiftUI does not support such changes within a single
    /// state update. For example, SwiftUI only supports pushing, presenting or dismissing one screen at a time. Any changes can be
    /// made to the routes passed to the transform closure, and where those changes are not supported within a single update by
    /// SwiftUI, an Effect stream of smaller permissible updates will be returned, interspersed with sufficient delays.
    ///
    /// - Parameter routes: The routes in their current state.
    /// - Parameter scheduler: The scheduler for scheduling delays. E.g. a test scheduler can be used in tests.
    /// - Parameter transform: A closure transforming the routes into their new state.
    /// - Returns: An Effect stream of actions with incremental updates to routes over time. If the proposed change is supported
    ///   within a single update, the Effect stream will include only one element.
    static func routeWithDelaysIfUnsupported(_ routes: [Route<Action.LocalAction.Screen>], scheduler: AnySchedulerOf<DispatchQueue>, _ transform: (inout [Route<Action.LocalAction.Screen>]) -> Void) -> Self {
        var transformedRoutes = routes
        transform(&transformedRoutes)
        let steps = RouteSteps.calculateSteps(from: routes, to: transformedRoutes)
        return .run { send in
            for await step in scheduledSteps(steps: steps, scheduler: scheduler) {
                await send(._local(.updateRoutes(step)))
            }
        }
    }

    /// Allows arbitrary changes to be made to the routes collection, even if SwiftUI does not support such changes within a single
    /// state update. For example, SwiftUI only supports pushing, presenting or dismissing one screen at a time. Any changes can be
    /// made to the routes passed to the transform closure, and where those changes are not supported within a single update by
    /// SwiftUI, an Effect stream of smaller permissible updates will be returned, interspersed with sufficient delays.
    ///
    /// - Parameter routes: The routes in their current state.
    /// - Parameter transform: A closure transforming the routes into their new state.
    /// - Returns: An Effect stream of actions with incremental updates to routes over time. If the proposed change is supported
    ///   within a single update, the Effect stream will include only one element.
    static func routeWithDelaysIfUnsupported(_ routes: [Route<Action.LocalAction.Screen>], _ transform: (inout [Route<Action.LocalAction.Screen>]) -> Void) -> Self {
        routeWithDelaysIfUnsupported(routes, scheduler: .main, transform)
    }
}

private func scheduledSteps<Screen>(steps: [[Route<Screen>]], scheduler: AnySchedulerOf<DispatchQueue>) -> AsyncStream<[Route<Screen>]> {
    guard let first = steps.first else { return .finished }
    let second = steps.dropFirst().first
    let remainder = steps.dropFirst(2)

    return AsyncStream { continuation in
        Task {
            do {
                continuation.yield(first)
                if let second {
                    continuation.yield(second)
                }

                for step in remainder {
                    try await scheduler.sleep(for: .milliseconds(650))
                    continuation.yield(step)
                }

                continuation.finish()
            } catch {
                continuation.finish()
            }
        }
    }
}
