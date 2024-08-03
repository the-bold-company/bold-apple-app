import ComposableArchitecture
import DomainEntities
import Foundation
import TCAExtensions

@Reducer
public struct CreditAccountDetailFeature {
    public struct State: Equatable {
        @BindingState var emoji: String?
        @BindingState var accountNameText: String = ""
        @BindingState var balance: Decimal = 0
        @BindingState var limit: Decimal?
        @BindingState var statementDate: Int?
        @BindingState var paymenyDueDate: Int?
        @BindingState var currency: Currency = .current

        var accountName: DefaultLengthConstrainedString {
            .init(accountNameText)
        }

        var createAccountProgress: LoadingProgress<AccountAPIResponse, CreateAccountFailure> = .idle

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
            case accountCreateSuccessfully(CreateAccountResponse)
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

            return .none

//            return createAccount(
//                .creditCard(
//                    accountName: state.accountName,
//                    icon: state.emoji,
//                    balance: .init(state.balance),
//                    currency: state.currency
//                )
//            )
//            .debounce(id: CancelId.createAccount, for: .milliseconds(200), scheduler: mainQueue)
//            .map(
//                success: { Action.delegate(.accountCreateSuccessfully($0)) },
//                failure: { Action.delegate(.failedToCreateAccount($0)) }
//            )
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .accountCreateSuccessfully(res):
            state.createAccountProgress = .loaded(.success(res.createdAccount))
            return .none
        case let .failedToCreateAccount(reason):
            state.createAccountProgress = .loaded(.failure(reason))
            return .none
        }
    }
}
