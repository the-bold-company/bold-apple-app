import ComposableArchitecture
import DomainEntities
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
        }

        @CasePathable
        public enum Delegate {
            case delegate
        }
    }

    private let investmentUseCase: InvestmentUseCaseInterface

    public init(investmentUseCase: InvestmentUseCaseInterface) {
        self.investmentUseCase = investmentUseCase
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { _, action in
            switch action {
            case .delegate:
                return .none
            case .forward:
                return .none
            case .binding, .destination:
                return .none
            }
        }
    }

//    private func loadTradeHistory(state: inout State) -> Effect<Action> {
//        guard state.transactionLoadingState != .loading else { return .none }
//
//        state.transactionLoadingState = .loading
//
//        return .run { send in
//            let transactionListResponse = await transactionListUseCase.getInOutTransactions()
//
//            switch transactionListResponse {
//            case let .success(transactionList):
//                await send(.delegate(.loadTransactionsSuccessfully(transactionList)))
//            case .failure:
//                break
//            }
//        }
//    }
}

public extension InvestmentPortfolioReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case addTradeOptionPickerRoute(AddInvestmentTradeOptionsReducer.State)
            case addTransactionRoute(AddPortfolioTransactionReducer.State)
        }

        public enum Action {
            case addTradeOptionPickerRoute(AddInvestmentTradeOptionsReducer.Action)
            case addTransactionRoute(AddPortfolioTransactionReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.addTradeOptionPickerRoute, action: \.addTradeOptionPickerRoute) {
                AddInvestmentTradeOptionsReducer()
            }

            Scope(state: \.addTransactionRoute, action: \.addTransactionRoute) {
                AddPortfolioTransactionReducer()
            }
        }
    }
}
