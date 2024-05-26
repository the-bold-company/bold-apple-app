import ComposableArchitecture
import DI
import InvestmentFeature
import LogInUseCase

@Reducer
public struct MiniAppReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        fileprivate let email = "hien.tran@fire.com"
        fileprivate let password = "Qwerty@123"

        var logInState: LoadingState<AuthenticatedUserEntity> = .idle

        public init() {}
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
            case logInSuccessfully(AuthenticatedUserEntity)
            case logInFailed(DomainError)
        }
    }

    @Dependency(\.mainQueue) var mainQueue
    let logInUseCase: LogInUseCaseProtocol

    enum CancelId { case logIn }

    public init() {
        self.logInUseCase = resolve(\.logInUseCase)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .forward(.logIn):
                guard state.logInState != .loading else {
                    return .none
                }
                state.logInState = .loading

                return .run { [email = state.email, password = state.password] send in

                    let result = await logInUseCase.login(email: email, password: password)

                    switch result {
                    case let .success(authenticatedUser):
                        await send(.delegate(.logInSuccessfully(authenticatedUser)))
                    case let .failure(error):
                        await send(.delegate(.logInFailed(error)))
                    }
                }
                .debounce(id: CancelId.logIn, for: .milliseconds(300), scheduler: mainQueue)
                .cancellable(id: CancelId.logIn, cancelInFlight: true)
            case let .delegate(.logInSuccessfully(user)):
                state.logInState = .loaded(user)
                state.destination = .miniAppEntryRoute(.init())
                return .none
            case let .delegate(.logInFailed(error)):
                state.logInState = .failure(error)
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

            let result = await logInUseCase.login(email: email, password: password)

            switch result {
            case let .success(authenticatedUser):
                await send(.delegate(.logInSuccessfully(authenticatedUser)))
            case let .failure(error):
                await send(.delegate(.logInFailed(error)))
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
            // case miniAppEntryRoute(StockSearchHomeReducer.State)
            case miniAppEntryRoute(InvestmentHomeReducer.State)
        }

        public enum Action {
            // case miniAppEntryRoute(StockSearchHomeReducer.Action)
            case miniAppEntryRoute(InvestmentHomeReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(
                state: \.miniAppEntryRoute,
                action: \.miniAppEntryRoute
            ) { resolve(\InvestmentFeatureContainer.investmentHomeReducer) }
            // { resolve(\InvestmentFeatureContainer.stockSearchHomeReducer) }
        }
    }
}
