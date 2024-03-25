import ComposableArchitecture
import DomainEntities
import Factory
import InvestmentUseCase
import SwiftUI

@Reducer
public struct InvestmentPortfolioReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        let portfolio: InvestmentPortfolioEntity

        public init(
            destination: Destination.State? = nil,
            portfolio: InvestmentPortfolioEntity
        ) {
            self.destination = destination
            self.portfolio = portfolio
        }
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum Forward {
            case onAppear
            case navigateToTradeImportOptions
        }

        @CasePathable
        public enum Delegate {
            case delegate
        }
    }

    @Dependency(\.dismiss) var dismiss
    private let investmentUseCase: InvestmentUseCaseInterface

    public init(investmentUseCase: InvestmentUseCaseInterface) {
        self.investmentUseCase = investmentUseCase
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .forward(.onAppear):
                return .none
            case .forward(.navigateToTradeImportOptions):
                state.destination = .investmentTradeImportOptionsRoute(.init(portfolio: state.portfolio))
                return .none
            case .delegate:
                return .none
            case .destination(.presented(.investmentTradeImportOptionsRoute(.destination(.presented(.addTransactionRoute(.delegate(.transactionAdded(_)))))))):
                return .run { _ in await dismiss() }
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

public extension InvestmentPortfolioReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case investmentTradeImportOptionsRoute(InvestmentTradeImportOptionsReducer.State)
            case addTransactionRoute(RecordPortfolioTransactionReducer.State)
        }

        public enum Action {
            case investmentTradeImportOptionsRoute(InvestmentTradeImportOptionsReducer.Action)
            case addTransactionRoute(RecordPortfolioTransactionReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.investmentTradeImportOptionsRoute, action: \.investmentTradeImportOptionsRoute) {
                resolve(\InvestmentFeatureContainer.investmentTradeImportOptionsReducer)
            }

            Scope(state: \.addTransactionRoute, action: \.addTransactionRoute) {
                resolve(\InvestmentFeatureContainer.recordPortfolioTransactionReducer)
            }
        }
    }
}
