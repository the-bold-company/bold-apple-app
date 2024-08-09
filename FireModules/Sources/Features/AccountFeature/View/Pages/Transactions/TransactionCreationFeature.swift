import ComposableArchitecture
import DomainEntities
import SwiftUI
import TCAExtensions

@CasePathable
enum TransactionEntityType: Equatable {
    case moneyIn
    case moneyOut
    case internalTransfer
}

@Reducer
public struct TransactionCreationFeature {
    public struct State: Equatable {
        @BindingState var transactionType: TransactionEntityType = .moneyIn
        @BindingState var amount: Decimal = 0
        @BindingState var date: Date
        @BindingState var category: Id = MoneyInCategory.undefined.id
        @BindingState var transactionName: String = ""

        var moneyInCategories: LoadingProgress<IdentifiedArrayOf<MoneyInCategory>, GetCategoriesFailure> = .idle
        var moneyOutCategories: LoadingProgress<IdentifiedArrayOf<MoneyOutCategory>, GetCategoriesFailure> = .idle

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

        @CasePathable
        public enum ViewAction {
            case onAppear
            case selectCategory(Id)
            case createNewCategory
        }

        @CasePathable
        public enum DelegateAction {
            case moneyInCategoriesFetched(IdentifiedArrayOf<MoneyInCategory>)
            case failedToFetchMoneyInCategories(GetCategoriesFailure)
            case moneyOutCategoriesFetched(IdentifiedArrayOf<MoneyOutCategory>)
            case failedToFetchMoneyOutCategories(GetCategoriesFailure)
        }

        @CasePathable
        public enum LocalAction {}
    }

    @Dependency(\.categoryUseCase) var categoryUseCase
    @Dependency(\.mainQueue) var mainQueue

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
            case .binding:
                return .none
            }
        }
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .merge(
                loadMoneyInCategories(state: &state),
                loadMoneyOutCategories(state: &state)
            )
        case let .selectCategory(id):
            state.category = id
            return .none
        case .createNewCategory:
            return .none
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .moneyInCategoriesFetched(categories):
            state.moneyInCategories = .loaded(.success(categories))
            return .none
        case let .failedToFetchMoneyInCategories(error):
            state.moneyInCategories = .loaded(.failure(error))
            return .none
        case let .moneyOutCategoriesFetched(categories):
            state.moneyOutCategories = .loaded(.success(categories))
            return .none
        case let .failedToFetchMoneyOutCategories(error):
            state.moneyOutCategories = .loaded(.failure(error))
            return .none
        }
    }

    private func handleLocalAction(_ action: Action.LocalAction, state _: inout State) -> Effect<Action> {
        switch action {}
        return .none
    }

    private func loadMoneyInCategories(state: inout State) -> Effect<Action> {
        enum CancelId { case getMoneyInCategories }

        state.moneyInCategories = .loading
        return categoryUseCase
            .getCategories(.moneyIn)
            .debounce(id: CancelId.getMoneyInCategories, for: .milliseconds(300), scheduler: mainQueue)
            .map(
                success: { .delegate(.moneyInCategoriesFetched($0[case: \.moneyIn]!)) },
                failure: { .delegate(.failedToFetchMoneyInCategories($0)) }
            )
    }

    private func loadMoneyOutCategories(state: inout State) -> Effect<Action> {
        enum CancelId { case getMoneyOutCategories }

        state.moneyOutCategories = .loading
        return categoryUseCase
            .getCategories(.moneyOut)
            .debounce(id: CancelId.getMoneyOutCategories, for: .milliseconds(300), scheduler: mainQueue)
            .map(
                success: { .delegate(.moneyOutCategoriesFetched($0[case: \.moneyOut]!)) },
                failure: { .delegate(.failedToFetchMoneyOutCategories($0)) }
            )
    }
}
