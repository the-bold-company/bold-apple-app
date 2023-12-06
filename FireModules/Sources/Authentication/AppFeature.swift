//
//  AppFeature.swift
//
//
//  Created by Hien Tran on 02/12/2023.
//

// import ComposableArchitecture
//
// @Reducer
// public struct RootFeature {
//    public init() {}
//    public struct State /*: Equatable*/ {
//        public var path = StackState<Path.State>()
//
//        public init(path: StackState<Path.State> = StackState<Path.State>()) {
//            self.path = path
//        }
//    }
//
//    public enum Action {
//        case path(StackAction<Path.State, Path.Action>)
////        case goBackToScreen(id: StackElementID)
////        case goToABCButtonTapped
////        case popToRoot
//    }
//
//    @Reducer
//    public struct Path {
//        public enum State /*: Equatable*/ {
//            case landingRoute(LandingFeature.State = .init())
//            case loginRoute
//            case registerEmail(EmailRegister.State = .init())
//            case registerPassword(PasswordCreationFeature.State = .init())
//        }
//
//        public enum Action {
//            case landingRoute(LandingFeature.Action)
//            case loginRoute
//            case registerEmail(EmailRegister.Action)
//            case registerPassword(PasswordCreationFeature.Action)
//        }
//
//        public var body: some ReducerOf<Self> {
//            Scope(state: \.landingRoute, action: \.landingRoute) {
//                LandingFeature()
//            }
//
//            Scope(state: \.loginRoute, action: \.loginRoute) {}
//
//            Scope(state: \.registerEmail, action: \.registerEmail) {
//                EmailRegister()
//            }
//
//            Scope(state: \.registerPassword, action: \.registerPassword) {
//                PasswordCreationFeature()
//            }
//        }
//    }
//
//    public var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case let .path(action):
//                switch action {
//                case .element(id: _, action: .landingRoute(.signUpButtonTapped)):
//                    state.path.append(.registerEmail())
//                    return .none
//                case .element(id: _, action: .registerEmail(.proceedButtonTapped)):
//                    state.path.append(.registerPassword())
//                    return .none
//                default:
//                    return .none
//                }
//            }
//        }
//        .forEach(\.path, action: \.path) {
//            Path()
//        }
//    }
// }
