import ComposableArchitecture
import DomainEntities
import Foundation
import TCAExtensions

@Reducer
public struct AccountViewFeature {
    public struct State: Equatable {
        @BindingState var emoji: String?
        @BindingState var accountNameText: String = ""
        @BindingState var balance: Decimal = 0
        @BindingState var currency: Currency = .current

        var createAccountProgress: LoadingProgress<BankAccount, CreateAccountFailure> = .idle

        var accountName: DefaultLengthConstrainedString {
            .init(accountNameText)
        }

        public init() {}
    }

    public enum Action: BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)

        @CasePathable
        public enum ViewAction {
            case cancelButtonTapped
            case createButtonTapped
        }

        @CasePathable
        public enum DelegateAction {
            case accountCreateSuccessfully(BankAccount)
            case failedToCreateAccount(CreateAccountFailure)
        }

        @CasePathable
        public enum LocalAction {}
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.accountUseCase.createAccount) var createAccount
    @Dependency(\.mainQueue) var mainQueue

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            }
        }
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .run { _ in await dismiss() }
        case .createButtonTapped:
            enum CancelId { case createAccount }

            state.createAccountProgress = .loading

            let accountName = state.accountName
            let emoji = state.emoji
            let balance = state.balance
            let currency = state.currency

            return createAccount(
                .bankAccount(
                    accountName: accountName,
                    icon: emoji,
                    balance: .init(balance, currency: currency)
                )
            )
            .debounce(id: CancelId.createAccount, for: .milliseconds(200), scheduler: mainQueue)
            .map(
                success: { success in
                    guard let createdAccount = success[case: \.bankAccount] else {
                        return Action.delegate(.failedToCreateAccount(.init(domainError: .custom(description: "Account created successfully but failed to read the response"))))
                    }

                    return Action.delegate(.accountCreateSuccessfully(createdAccount))

                },
                failure: { Action.delegate(.failedToCreateAccount($0)) }
            )
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .accountCreateSuccessfully(createdAccount):
            state.createAccountProgress = .loaded(.success(createdAccount))
            return .run { _ in await dismiss() }.animation()
        case let .failedToCreateAccount(reason):
            state.createAccountProgress = .loaded(.failure(reason))
            return .none
        }
    }
}