import ComposableArchitecture
import Factory
import Foundation
import LiveMarketUseCase
// import MarketAPIService

@Reducer
public struct StockSearchHomeReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var loadTrendingStockState: LoadingState<IdentifiedArrayOf<SymbolDisplayEntity>> = .idle

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
        }

        @CasePathable
        public enum Delegate {}
    }

    private let liveMarketUseCase: LiveMarketUseCaseInterface

    public init(liveMarketUseCase: LiveMarketUseCaseInterface) {
        self.liveMarketUseCase = liveMarketUseCase
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .forward(.activeSearch):
                state.destination = .stockSearchRoute(.init(searchedTerm: state.searchedTerm))
                return .none
            case let .destination(.presented(.stockSearchRoute(.delegate(.onDismissing(searchedTerm))))):
                state.searchedTerm = searchedTerm
                return .none
            case .binding, .destination, .forward:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

public extension StockSearchHomeReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case stockSearchRoute(StockSearchReducer.State)
        }

        public enum Action {
            case stockSearchRoute(StockSearchReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.stockSearchRoute, action: \.stockSearchRoute) {
                resolve(\InvestmentFeatureContainer.stockSearchReducer)
            }
        }
    }
}
