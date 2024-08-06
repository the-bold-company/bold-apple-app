import AccountFeature
import ComposableArchitecture
import CoreUI
import SwiftUI
import TCAExtensions

@Reducer
public struct HomeFeature {
    @Reducer(state: .equatable)
    public enum Destination {
        case overview(OverviewFeature)
        case reports(ReportFeature)
        case accounts(AccountsOverviewFeature)
        case transactions(TransactionsOverviewFeature)
        case categories(CategoriesFeature)
        case createBankAccount(AccountViewFeature)
        case createCreditAccount(CreditAccountDetailFeature)
    }

    @Reducer(state: .equatable)
    public enum ModalDestination {
        case createBankAccount1(AccountViewFeature)
        case createCreditAccount1(CreditAccountDetailFeature)
    }

    public struct State: Equatable {
        @PresentationState var destination: Destination.State? = .overview(.init())
        @PresentationState var modalDestination: ModalDestination.State?
        public init() {}

        var something: String = ""
    }

    public enum Action: BindableAction {
        case destination(PresentationAction<Destination.Action>)
        case modalDestination(PresentationAction<ModalDestination.Action>)
        case binding(BindingAction<State>)
//        case delegate(DelegateAction)
//        case _local(LocalAction)
        case view(ViewAction)

//        @CasePathable
//        public enum LocalAction {}
//
//        @CasePathable
//        public enum DelegateAction {}

        @CasePathable
        public enum ViewAction {
            case goToOverview
            case goToReports
            case goToAccounts
            case goToTransactions
            case goToCategories
            case manualBankAccountCreationTapped
            case manualCreditAccountCreationTapped
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case .destination, .binding, .modalDestination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$modalDestination, action: \.modalDestination)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .goToOverview:
            state.destination = .overview(.init())
        case .goToReports:
            state.destination = .reports(.init())
        case .goToAccounts:
            state.destination = .accounts(.init())
        case .goToTransactions:
            state.destination = .transactions(.init())
        case .goToCategories:
            state.destination = .categories(.init())
        case .manualBankAccountCreationTapped:
//            state.modalDestination = .createBankAccount(.init())
            state.destination = .createBankAccount(.init())
        case .manualCreditAccountCreationTapped:
//            state.modalDestination = .createCreditAccount(.init())
            state.destination = .createCreditAccount(.init())
        }
        return .none
    }
}
