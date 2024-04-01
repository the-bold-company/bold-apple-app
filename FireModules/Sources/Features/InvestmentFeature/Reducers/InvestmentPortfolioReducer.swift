import ComposableArchitecture
import DomainEntities
import Factory
import InvestmentUseCase
import LiveMarketUseCase
import SwiftUI

@Reducer
public struct InvestmentPortfolioReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        var portfolio: InvestmentPortfolioEntity

        var reloadPortfolioState: LoadingState<InvestmentPortfolioEntity> = .idle
        var calculatingAvailableCashState: LoadingState<Money> = .idle

        var balances: [Money] {
            return portfolio.balances
        }

        var areBalancesValid: Result<Void, DomainError> {
            for balance in balances where !balance.isValid {
                return .failure(DomainError(error: balance.errorOnly.this!))
            }

            return .success(())
        }

        var isBalanceNotEmpty: Bool {
            return !balances.isEmpty
        }

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
            case onCashBalanceTapped
        }

        @CasePathable
        public enum Delegate {
            case portfolioReloaded(InvestmentPortfolioEntity)
            case failedToReloadPortfolio(DomainError)
            case availableCashConverted(Money)
            case failedToConvertAvailableCash(DomainError)
        }
    }

    @Dependency(\.dismiss) var dismiss
    private let investmentUseCase: InvestmentUseCaseInterface
    private let liveMarketUseCase: LiveMarketUseCaseInterface

    public init(investmentUseCase: InvestmentUseCaseInterface, liveMarketUseCase: LiveMarketUseCaseInterface) {
        self.investmentUseCase = investmentUseCase
        self.liveMarketUseCase = liveMarketUseCase
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .forward(.onAppear):
                guard state.calculatingAvailableCashState == .idle else { return .none }
                return calculateAvailableCash(state: &state)
            case .forward(.navigateToTradeImportOptions):
                state.destination = .investmentTradeImportOptionsRoute(.init(portfolio: state.portfolio))
                return .none
            case .forward(.onCashBalanceTapped):
                state.destination = .investmentCashBalanceRoute(.init(portfolio: state.portfolio))
                return .none
            case let .delegate(.portfolioReloaded(portfolio)):
                state.reloadPortfolioState = .loaded(portfolio)
                state.portfolio = portfolio
                return .none
            case let .delegate(.failedToReloadPortfolio(error)):
                state.reloadPortfolioState = .failure(error)
                return .none
            case let .delegate(.availableCashConverted(amount)):
                state.calculatingAvailableCashState = .loaded(amount)
                return .none
            case let .delegate(.failedToConvertAvailableCash(error)):
                state.calculatingAvailableCashState = .failure(error)
                return .none
            case .destination(.presented(.investmentTradeImportOptionsRoute(.destination(.presented(.addTransactionRoute(.delegate(.transactionAdded(_)))))))):
                return loadPortfolio(state: &state)
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }

    private func loadPortfolio(state: inout State) -> Effect<Action> {
        guard state.reloadPortfolioState != .loading else { return .none }

        state.reloadPortfolioState = .loading
        return .run { [id = state.portfolio.id.dynamodbCompartibleUUIDString] send in
            let result = await investmentUseCase.getPortfolioDetails(id: id)
            switch result {
            case let .success(portfolio):
                await send(.delegate(.portfolioReloaded(portfolio)))
            case let .failure(error):
                await send(.delegate(.failedToReloadPortfolio(error)))
            }
        }
    }

    private func calculateAvailableCash(state: inout State) -> Effect<Action> {
        guard state.isBalanceNotEmpty,
              state.calculatingAvailableCashState != .loading
        else { return .none }

        if case let .failure(error) = state.areBalancesValid {
            state.calculatingAvailableCashState = .failure(error)
            return .none
        } else {
            state.calculatingAvailableCashState = .loading

            return .run { [portfolio = state.portfolio, balances = state.balances] send in
                var totalAmount = balances
                    .filter { $0.currency == portfolio.baseCurrency }
                    .reduce(Money.zero(currency: portfolio.baseCurrency)) {
                        $0 + $1
                    }

                    outerLoop: for balance in balances where balance.currency != portfolio.baseCurrency
                {
                    let result = await liveMarketUseCase.convertCurrency(money: balance, to: portfolio.baseCurrency)

                    switch result {
                    case let .success(conversion):
                        totalAmount += conversion.convertedAmount
                    case let .failure(error):
                        await send(.delegate(.failedToReloadPortfolio(error)))
                        break outerLoop
                    }
                }

                await send(.delegate(.availableCashConverted(totalAmount)))
            }
        }
    }
}

public extension InvestmentPortfolioReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case investmentTradeImportOptionsRoute(InvestmentTradeImportOptionsReducer.State)
            case investmentCashBalanceRoute(InvestmentCashBalanceReducer.State)
        }

        public enum Action {
            case investmentTradeImportOptionsRoute(InvestmentTradeImportOptionsReducer.Action)
            case investmentCashBalanceRoute(InvestmentCashBalanceReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.investmentTradeImportOptionsRoute, action: \.investmentTradeImportOptionsRoute) {
                resolve(\InvestmentFeatureContainer.investmentTradeImportOptionsReducer)
            }

            Scope(state: \.investmentCashBalanceRoute, action: \.investmentCashBalanceRoute) {
                resolve(\InvestmentFeatureContainer.investmentCashBalanceReducer)
            }
        }
    }
}
