import ComposableArchitecture
import DomainEntities
import Foundation
import TCAExtensions

@Reducer
public struct AccountViewFeature {
    public struct State: Equatable {
        @BindingState var emoji: String = ""
        @BindingState var accountNameText: String = ""
        @BindingState var balance: Decimal = 0
        @BindingState var currency: Currency = .current

        var createAccountProgress: LoadingProgress<String, CreateAccountFailure> = .idle

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
            case accountCreateSuccessfully
            case failedToCreateAccount(CreateAccountFailure)
        }

        @CasePathable
        public enum LocalAction {}
    }

    public init() {}

    @Dependency(\.AccountUseCase.createAccount) var createAccount
    @Dependency(\.mainQueue) var mainQueue

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
            return .none
        case .createButtonTapped:
            enum CancelId { case createAccount }

            state.createAccountProgress = .loading

            return createAccount(
                .bankAccount(
                    accountName: state.accountName,
                    icon: state.emoji,
                    balance: .init(state.balance),
                    currency: state.currency
                )
            )
            .debounce(id: CancelId.createAccount, for: .milliseconds(200), scheduler: mainQueue)
            .map(
                success: { _ in Action.delegate(.accountCreateSuccessfully) },
                failure: { Action.delegate(.failedToCreateAccount($0)) }
            )
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case .accountCreateSuccessfully:
            state.createAccountProgress = .loaded(.success(""))
            return .none
        case let .failedToCreateAccount(reason):
            state.createAccountProgress = .loaded(.failure(reason))
            return .none
        }
    }
}
