import ComposableArchitecture
import DomainEntities
import Foundation

@Reducer
public struct InvestmentCashBalanceReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var portfolio: InvestmentPortfolioEntity

        public init(portfolio: InvestmentPortfolioEntity) {
            self.portfolio = portfolio
        }
    }

    public enum Action: BindableAction {
        case forward(Forward)
        case delegate(Delegate)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum Forward {
            case forwardCase
        }

        @CasePathable
        public enum Delegate {
            case delegateCase
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { _, action in
            switch action {
            case .delegate:
                return .none
            case .forward:
                return .none
            case .destination:
                return .none
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

public extension InvestmentCashBalanceReducer {
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
