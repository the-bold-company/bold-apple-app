import ComposableArchitecture
import SwiftUI
import TCAExtensions

@CasePathable
enum TransactionType: Equatable {
    case moneyIn
    case moneyOut
    case internalTransfer
}

@Reducer
public struct TransactionDetailFeature {
    @Reducer(state: .equatable)
    public enum Destination {
        case destination1
    }

    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        @BindingState var transactionType: TransactionType = .moneyIn
        @BindingState var amount: Decimal = 0
        @BindingState var date: Date
        @BindingState var category: String = "Không xác định (Mặc định)"
        @BindingState var transactionName: String = ""

        public init() {
            @Dependency(\.date.now) var currentDate
            self.date = currentDate
        }
    }

    public enum Action: FeatureAction, BindableAction {
        case delegate(DelegateAction)
        case view(ViewAction)
        case _local(LocalAction)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum ViewAction {}

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
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            case let ._local(localAction):
                return handleLocalAction(localAction, state: &state)
            case .binding, .destination:
                return .none
            }
        }
    }

    private func handleViewAction(_ action: Action.ViewAction, state _: inout State) -> Effect<Action> {
        switch action {}
        return .none
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state _: inout State) -> Effect<Action> {
        switch action {}
        return .none
    }

    private func handleLocalAction(_ action: Action.LocalAction, state _: inout State) -> Effect<Action> {
        switch action {}
        return .none
    }
}
