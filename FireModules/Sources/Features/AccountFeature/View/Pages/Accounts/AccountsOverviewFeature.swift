import CasePaths
import ComposableArchitecture
import SwiftUI
import TCAExtensions

@Reducer
public struct AccountsOverviewFeature {
//    @Reducer(state: .equatable)
//    public enum Destination {
//        case createAccount
//    }

    public struct State: Equatable {
        var createAccount = AccountViewFeature.State()

        public init() {}
    }

    public enum Action: FeatureAction {
        case _local(LocalAction)
        case delegate(DelegateAction)
        case view(ViewAction)

        @CasePathable
        public enum ViewAction {}

        @CasePathable
        public enum DelegateAction {}

        @CasePathable
        public enum LocalAction {
            case createAccount(AccountViewFeature.Action)
        }
    }

    public init() {}
    public var body: some ReducerOf<Self> {
        Scope(state: \.createAccount, action: \._local.createAccount) {
            AccountViewFeature()
        }

        Reduce { _, _ in
            return .none
        }
    }
}
