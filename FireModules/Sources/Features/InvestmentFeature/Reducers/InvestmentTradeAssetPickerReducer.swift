import ComposableArchitecture
import Factory
import Foundation

@Reducer
public struct InvestmentTradeAssetPickerReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        let assetTypes: IdentifiedArrayOf<AssetType> = IdentifiedArray(uniqueElements: AssetType.allCases)
        public init() {}
    }

    public enum Action: BindableAction {
        case forward(Forward)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum Forward {
            case selectAssetType(AssetType)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .forward(.selectAssetType(asset)):
                guard let selection = state.assetTypes[id: asset] else { return .none }

                if selection == AssetType.stocks {
                    state.destination = .stockSearchHomeRoute(.init())
                } else {
                    state.destination = .underConstructionRoute
                }

                return .none
            case .destination, .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

public extension InvestmentTradeAssetPickerReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case underConstructionRoute
            case stockSearchHomeRoute(StockSearchHomeReducer.State)
        }

        public enum Action {
            case underConstructionRoute
            case stockSearchHomeRoute(StockSearchHomeReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.stockSearchHomeRoute, action: \.stockSearchHomeRoute) {
                resolve(\InvestmentFeatureContainer.stockSearchHomeReducer)
            }
        }
    }
}

public enum AssetType: String, CaseIterable, Identifiable {
    public var id: AssetType { return self }

    case crypto = "Crypto"
    case stocks = "Stocks"
    case indices = "Indices"
    case funds = "Funds"
    case commodities = "Commodities"
    case nft = "NFT"
    case realEstate = "Real Estate"
    case forex = "Forex"
}
