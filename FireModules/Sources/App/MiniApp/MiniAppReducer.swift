// import LogInUseCase
import AuthenticationUseCase
import ComposableArchitecture
import DI
import Factory
import InvestmentFeature

@Reducer
public struct MiniAppReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        fileprivate let email = "hien.tran@fire.com"
        fileprivate let password = "Qwerty@123"

        var logInState: LoadingProgress<AuthenticatedUserEntity, AuthenticationLogic.LogIn.Failure> = .idle

        let logInRequired: Bool

        public init(logInRequired: Bool) {
            self.logInRequired = logInRequired
        }
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum Forward {
            case logIn
        }

        @CasePathable
        public enum Delegate {
            case logInSuccesfully(AuthenticationLogic.LogIn.Response)
            case logInFailure(AuthenticationLogic.LogIn.Failure)
        }
    }

    @Dependency(\.mainQueue) var mainQueue
    private let logInUseCase: LogInUseCase

    enum CancelId { case logIn }

    public init() {
        self.logInUseCase = resolve(\.logInUseCase)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .forward(.logIn):
                guard state.logInRequired else {
                    state.destination = .miniAppEntryRoute(.init())
                    return .none
                }

                guard state.logInState != .loading else {
                    return .none
                }
                state.logInState = .loading

                return .run { [email = state.email, password = state.password] send in

                    let result = await logInUseCase.logInAsync(.init(email: email, password: password))

                    switch result {
                    case let .success(response):
                        await send(.delegate(.logInSuccesfully(response)))
                    case let .failure(error):
                        await send(.delegate(.logInFailure(error)))
                    }
                }
                .debounce(id: CancelId.logIn, for: .milliseconds(300), scheduler: mainQueue)
                .cancellable(id: CancelId.logIn, cancelInFlight: true)
            case let .delegate(.logInSuccesfully(response)):
                state.logInState = .loaded(.success(response.user))
                state.destination = .miniAppEntryRoute(.init())
                return .none
            case let .delegate(.logInFailure(error)):
                state.logInState = .loaded(.failure(error))
                return .none
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }

    private func logIn(state: inout State) -> Effect<Action> {
        state.logInState = .loading

        return .run { [email = state.email, password = state.password] send in

            let result = await logInUseCase.logInAsync(.init(email: email, password: password))

            switch result {
            case let .success(response):
                await send(.delegate(.logInSuccesfully(response)))
            case let .failure(error):
                await send(.delegate(.logInFailure(error)))
            }
        }
        .debounce(id: CancelId.logIn, for: .milliseconds(300), scheduler: mainQueue)
        .cancellable(id: CancelId.logIn, cancelInFlight: true)
    }
}

public extension MiniAppReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case miniAppEntryRoute(LogInFeature.State)
        }

        public enum Action {
            // case miniAppEntryRoute(StockSearchHomeReducer.Action)
            case miniAppEntryRoute(LogInFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(
                state: \.miniAppEntryRoute,
                action: \.miniAppEntryRoute
            ) {
                LogInFeature()
            }
        }
    }
}
