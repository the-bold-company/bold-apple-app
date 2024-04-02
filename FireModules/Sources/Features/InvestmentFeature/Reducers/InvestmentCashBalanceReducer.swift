import ComposableArchitecture
import DomainEntities
import Foundation
import InvestmentUseCase

@Reducer
public struct InvestmentCashBalanceReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var portfolio: InvestmentPortfolioEntity

        var transactionHistoryLoadingState: LoadingState<[InvestmentTransactionEntity]> = .idle

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
            case onAppear
        }

        @CasePathable
        public enum Delegate {
            case transactionHistoryLoaded([InvestmentTransactionEntity])
            case failedToLoadTransactionHistory(DomainError)
        }
    }

    private let investmentUseCase: InvestmentUseCaseInterface

    public init(investmentUseCase: InvestmentUseCaseInterface) {
        self.investmentUseCase = investmentUseCase
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .forward(.onAppear):
                guard state.transactionHistoryLoadingState == .idle else { return .none }
                return loadTransactions(state: &state)
            case let .delegate(.transactionHistoryLoaded(transactions)):
                state.transactionHistoryLoadingState = .loaded(transactions)
                return .none
            case let .delegate(.failedToLoadTransactionHistory(error)):
                state.transactionHistoryLoadingState = .failure(error)
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

    private func loadTransactions(state: inout State) -> Effect<Action> {
        guard state.transactionHistoryLoadingState != .loading else { return .none }

        state.transactionHistoryLoadingState = .loading

        return .run { [id = state.portfolio.id] send in
            let result = await investmentUseCase.getTransactionHistory(portfolioId: id)
            switch result {
            case let .success(transactions):
                await send(.delegate(.transactionHistoryLoaded(transactions)))
            case let .failure(error):
                await send(.delegate(.failedToLoadTransactionHistory(error)))
            }
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
