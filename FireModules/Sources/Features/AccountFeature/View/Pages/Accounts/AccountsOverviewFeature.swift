import CasePaths
import ComposableArchitecture
import DomainEntities
import SwiftUI
import TCAExtensions

@Reducer
public struct AccountsOverviewFeature {
    @Reducer(state: .equatable)
    public enum Destination {
        case createBankAccount(AccountViewFeature)
        case createCreditAccount(CreditAccountDetailFeature)
    }

    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        var getAccountsStatus: LoadingProgress<[AnyAccount], GetAccountListFailure> = .idle

        var accounts: IdentifiedArrayOf<AnyAccount> = []

        var createAccount = AccountViewFeature.State()

        public init() {}
    }

    public enum Action: FeatureAction, BindableAction {
        case _local(LocalAction)
        case delegate(DelegateAction)
        case view(ViewAction)
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)

        @CasePathable
        public enum ViewAction {
            case manualBankAccountCreationTapped
            case manualCreditAccountCreationTapped
            case onAppear
        }

        @CasePathable
        public enum DelegateAction {
            case getAccountSuccessfully([AnyAccount])
            case failedToGetAccounts(GetAccountListFailure)
        }

        @CasePathable
        public enum LocalAction {
            case createAccount(AccountViewFeature.Action)
        }
    }

    @Dependency(\.mainQueue) private var mainQueue
    @Dependency(\.accountUseCase) private var accountUseCase

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.createAccount, action: \._local.createAccount) {
            AccountViewFeature()
        }

        Reduce { state, action in
            switch action {
            case ._local:
                return .none
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            case let .destination(destinationAction):
                return handleDestinationDelegation(destinationAction, state: &state)
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .manualBankAccountCreationTapped:
            state.destination = .createBankAccount(state.createAccount)
            return .none.animation()
        case .manualCreditAccountCreationTapped:
            state.destination = .createCreditAccount(.init())
            return .none.animation()
        case .onAppear:
            enum CancelId { case getAccounts }
            state.getAccountsStatus = .loading

            return accountUseCase
                .getAccountList(GetAccountListInput())
                .debounce(id: CancelId.getAccounts, for: .milliseconds(500), scheduler: mainQueue)
                .map(
                    success: { Action.delegate(.getAccountSuccessfully($0.accounts)) },
                    failure: { Action.delegate(.failedToGetAccounts($0)) }
                )
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .getAccountSuccessfully(accounts):
            state.getAccountsStatus = .loaded(.success(accounts))
            state.accounts = .init(uniqueElements: accounts)
            return .none
        case let .failedToGetAccounts(error):
            state.getAccountsStatus = .loaded(.failure(error))
            return .none
        }
    }

    private func handleDestinationDelegation(_ action: PresentationAction<AccountsOverviewFeature.Destination.Action>, state: inout State) -> Effect<Action> {
        switch action {
        case .dismiss:
            return .none
        case let .presented(.createCreditAccount(.delegate(.accountCreateSuccessfully(createdAccount)))):
            state.accounts.append(AnyAccount(createdAccount))
            return .none
        case let .presented(.createBankAccount(.delegate(.accountCreateSuccessfully(createdAccount)))):
            state.accounts.append(AnyAccount(createdAccount))
            return .none
        default:
            return .none
        }
    }
}
