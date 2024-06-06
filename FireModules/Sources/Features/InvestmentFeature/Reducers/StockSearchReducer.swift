
import ComposableArchitecture
import Factory
import Foundation
import LiveMarketUseCase
// import MarketAPIService

@Reducer
public struct StockSearchReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        var searchLoadingState: LoadingState<IdentifiedArrayOf<SymbolDisplayEntity>> = .idle
        @BindingState var searchedTerm: String
        @BindingState var isSearchFocused: Bool = true

        public init(searchedTerm: String? = nil) {
            self.searchedTerm = searchedTerm ?? ""
        }
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum Forward {
            case cancelButtonTapped
        }

        @CasePathable
        public enum Delegate {
            case searchResult([SymbolDisplayEntity])
            case searchFailed(DomainError)
            case onDismissing(searchedTerm: String)
        }
    }

    private enum CancelId { case search }
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.dismiss) var dismiss

    private let liveMarketUseCase: LiveMarketUseCaseInterface

    public init(liveMarketUseCase: LiveMarketUseCaseInterface) {
        self.liveMarketUseCase = liveMarketUseCase
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .forward(.cancelButtonTapped):
                state.isSearchFocused = false
                return .run { [searchedTerm = state.searchedTerm] send in
                    await send(.delegate(.onDismissing(searchedTerm: searchedTerm)))
                    await dismiss()
                }
            case .delegate(.onDismissing):
                return .none
            case let .delegate(.searchResult(symbols)):
                state.searchLoadingState = .loaded(
                    IdentifiedArray(symbols) { first, _ in return first }
                )
                return .none
            case let .delegate(.searchFailed(error)):
                state.searchLoadingState = .failure(error)
                return .none
            case .destination:
                return .none
            case .binding(\.$searchedTerm):
                guard state.searchedTerm.isNotEmpty else {
                    state.searchLoadingState = .idle
                    return .cancel(id: CancelId.search)
                }

                state.searchLoadingState = .loading
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
            case .binding, .forward:
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
        public enum State: Equatable {}

        public enum Action {}

        public var body: some ReducerOf<Self> {
            EmptyReducer()
        }
    }
}
