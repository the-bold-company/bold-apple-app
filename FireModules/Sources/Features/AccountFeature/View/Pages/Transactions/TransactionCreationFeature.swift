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
        @BindingState var referenceAccount: AnyAccount?
        @BindingState var transactionName: String = ""
        @BindingState var notes: String = ""

        var moneyInCategories: LoadingProgress<IdentifiedArrayOf<MoneyInCategory>, GetCategoriesFailure> = .idle
        var moneyOutCategories: LoadingProgress<IdentifiedArrayOf<MoneyOutCategory>, GetCategoriesFailure> = .idle
        var accountList: LoadingProgress<IdentifiedArrayOf<AnyAccount>, GetAccountListFailure> = .idle
        var createTransactionProgress: LoadingProgress<Transaction, CreateTransactionFailure> = .idle

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
            case createTransactionButtonTapped
            case cancelButtonTapped
        }

        @CasePathable
        public enum DelegateAction {
            case moneyInCategoriesFetched(IdentifiedArrayOf<MoneyInCategory>)
            case failedToFetchMoneyInCategories(GetCategoriesFailure)
            case moneyOutCategoriesFetched(IdentifiedArrayOf<MoneyOutCategory>)
            case failedToFetchMoneyOutCategories(GetCategoriesFailure)
            case accountListFetched(IdentifiedArrayOf<AnyAccount>)
            case failedToFetchAccountList(GetAccountListFailure)
            case transactionCreated(Transaction)
            case failedToCreateTransaction(CreateTransactionFailure)
        }

        @CasePathable
        public enum LocalAction {}
    }

    @Dependency(\.accountUseCase.getAccountList) var getAccountList
    @Dependency(\.categoryUseCase) var categoryUseCase
    @Dependency(\.transactionUseCase.createTransaction) var createTransaction
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.dismiss) var dismiss

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
                fetchAccountList(state: &state),
                loadMoneyInCategories(state: &state),
                loadMoneyOutCategories(state: &state)
            )
        case let .selectCategory(id):
            state.category = id
            return .none
        case .createNewCategory:
            return .none
        case .createTransactionButtonTapped:
            enum CancelId { case createTransaction }

            guard let account = state.referenceAccount else { return .none }

            state.createTransactionProgress = .loading

            let amount = state.amount
            let date = state.date
            let categoryId = state.category
            let name = state.transactionName
            let note = state.notes

            return createTransaction(.moneyIn(
                amount: Money(amount, currency: account.currency),
                accountId: account.id,
                timestamp: Timestamp(date),
                categoryId: categoryId,
                name: DefaultLengthConstrainedString(name),
                note: DefaultLengthConstrainedString(note)
            ))
            .debounce(id: CancelId.createTransaction, for: .milliseconds(300), scheduler: mainQueue)
            .map(
                success: {
                    guard let transaction = $0[case: \.moneyIn] else {
                        return .delegate(.failedToCreateTransaction(.init(domainError: .custom(description: "Transaction created successfully but failed to read the response"))))
                    }

                    return .delegate(.transactionCreated(transaction))
                },
                failure: { .delegate(.failedToCreateTransaction($0)) }
            )
        case .cancelButtonTapped:
            return .run { _ in await dismiss() }
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
        case let .transactionCreated(transaction):
            state.createTransactionProgress = .loaded(.success(transaction))
            return .run { _ in await dismiss() }
        case let .failedToCreateTransaction(error):
            state.createTransactionProgress = .loaded(.failure(error))
            return .none
        case let .accountListFetched(accounts):
            state.referenceAccount = accounts.first!
            state.accountList = .loaded(.success(accounts))
            return .none
        case let .failedToFetchAccountList(error):
            state.accountList = .loaded(.failure(error))
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

    private func fetchAccountList(state: inout State) -> Effect<Action> {
        enum CancelId { case getAccountList }

        state.accountList = .loading
        return getAccountList(.init())
            .debounce(id: CancelId.getAccountList, for: .milliseconds(300), scheduler: mainQueue)
            .map(
                success: { .delegate(.accountListFetched($0.accounts)) },
                failure: { .delegate(.failedToFetchAccountList($0)) }
            )
    }
}
