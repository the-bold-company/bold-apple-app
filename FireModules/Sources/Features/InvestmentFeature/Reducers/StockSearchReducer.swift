import ComposableArchitecture
import Foundation
import LiveMarketUseCase

@Reducer
public struct StockSearchReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        var isSearchActive = false

        var searchState: LoadingState<IdentifiedArrayOf<SymbolDisplayEntity>> = .idle
        var loadTrendingStoclState: LoadingState<IdentifiedArrayOf<SymbolDisplayEntity>> = .idle
        @BindingState var searchedTerm: String = ""

        public init() {}
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum Forward {
            case activeSearch
            case cancelSearch
//            case startSearching
        }

        @CasePathable
        public enum Delegate {
            case searchResult([SymbolDisplayEntity])
            case searchFailed(DomainError)
        }
    }

    private enum CancelId { case search }

    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.continuousClock) var clock

    private let liveMarketUseCase: LiveMarketUseCaseInterface

    public init(liveMarketUseCase: LiveMarketUseCaseInterface) {
        self.liveMarketUseCase = liveMarketUseCase
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .forward(.activeSearch):
                state.isSearchActive = true
                return .none
            case .forward(.cancelSearch):
                state.isSearchActive = false
                return .none
            case let .delegate(.searchResult(symbols)):
                state.searchState = .loaded(
                    IdentifiedArray(symbols) { first, _ in return first }
                )
                return .none
            case let .delegate(.searchFailed(error)):
                state.searchState = .failure(error)
                return .none
            case .destination:
                return .none
            case .binding(\.$searchedTerm):
                guard state.searchedTerm.isNotEmpty else {
                    state.searchState = .idle
                    return .cancel(id: CancelId.search)
                }

                state.searchState = .loading
                return .run { [query = state.searchedTerm] send in
                    let searchedResult = await liveMarketUseCase.searchSymbol(query)
                    switch searchedResult {
                    case let .success(searchedSymbols):
                        await send(.delegate(.searchResult(searchedSymbols)))
                    case let .failure(error):
                        await send(.delegate(.searchFailed(error)))
                    }
                }
                .debounce(id: CancelId.search, for: .milliseconds(500), scheduler: mainQueue)
                .cancellable(id: CancelId.search, cancelInFlight: true)
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

public extension StockSearchReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case route
        }

        public enum Action {
            case route
        }

        public var body: some ReducerOf<Self> {
            Reduce { _, _ in
                return .none
            }
        }
    }
}

extension Result where Failure == DomainError {
    func perform(
        onSuccess: (Success) -> Void,
        onFailure: (DomainError) -> Void
    ) {
        switch self {
        case let .success(success):
            onSuccess(success)
        case let .failure(failure):
            onFailure(failure)
        }
    }
}
