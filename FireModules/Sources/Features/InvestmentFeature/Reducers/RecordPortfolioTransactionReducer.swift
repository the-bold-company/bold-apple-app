import ComposableArchitecture
import DomainEntities
import Factory
import InvestmentUseCase
import SwiftUI

enum TransactionType: String {
    case deposit
    case withdraw
}

@Reducer
public struct RecordPortfolioTransactionReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var currency = Currency.usd
        @BindingState var tradeTime: Date
        @BindingState var amount: Int = 0
        @BindingState var notes = ""
        var transactionType: TransactionType = .deposit
        var submissionState: LoadingState<InvestmentTransactionEntity> = .idle

        /// Because `CurrencyField` use Int to process the decimal digits, we need to convert it to the actual Decimal amount. TODO: - Fix this
        var actualAmount: Decimal {
            return Decimal(amount) / 100
        }

        var isFormValid: Bool {
            return amount > 0
        }

        let portfolio: InvestmentPortfolioEntity
        public init(portfolio: InvestmentPortfolioEntity) {
            @Dependency(\.date) var date
            self.tradeTime = date.now
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
            case openCurrencyPicker
            case selectDepositTransactionType
            case selectWithdrawTransactionType
            case addTransactionButtonTapped
        }

        @CasePathable
        public enum Delegate {
            case transactionAdded(InvestmentTransactionEntity)
            case failedToAddTransaction(DomainError)
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
            case .forward(.openCurrencyPicker):
                state.destination = .currencyPickerRoute(.init(currentlySelected: state.currency))
                return .none
            case .forward(.selectDepositTransactionType):
                state.transactionType = .deposit
                return .none
            case .forward(.selectWithdrawTransactionType):
                state.transactionType = .withdraw
                return .none
            case .forward(.addTransactionButtonTapped):
                guard state.isFormValid else { return .none }
                state.submissionState = .loading

                return .run { [amount = state.actualAmount, portfolioId = state.portfolio.id, type = state.transactionType.rawValue, currencyCode = state.currency.code, notes = state.notes] send in
                    let result = await investmentUseCase.recordTransaction(
                        amount: amount,
                        portfolioId: portfolioId,
                        type: type,
                        currency: currencyCode.rawValue,
                        notes: notes
                    )
                    switch result {
                    case let .success(transaction):
                        await send(.delegate(.transactionAdded(transaction)))
                    case let .failure(error):
                        await send(.delegate(.failedToAddTransaction(error)))
                    }
                }
            case let .delegate(.transactionAdded(transaction)):
                state.submissionState = .loaded(transaction)
                return .run { _ in await dismiss() }
            case let .delegate(.failedToAddTransaction(error)):
                state.submissionState = .failure(error)
                state.destination = .recordTransactionFailureAlert(
                    AlertState {
                        TextState("Unable to record transaction")
                    } actions: {
                        ButtonState(role: .cancel, action: .okButtonTapped) {
                            TextState("Ok")
                        }
                    } message: {
                        TextState(error.failureReason ?? "An error has occured")
                    }
                )

                return .none
            case let .destination(.presented(.currencyPickerRoute(.selectCurrency(selectedCurrency)))):
                state.currency = selectedCurrency
                return .none
            case .destination(.presented(.recordTransactionFailureAlert(.okButtonTapped))):
                state.destination = nil
                return .none
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

public extension RecordPortfolioTransactionReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case currencyPickerRoute(CurrencyPickerReducer.State)
            case recordTransactionFailureAlert(AlertState<Action.RecordTransactionFailureAlert>)
        }

        public enum Action {
            case currencyPickerRoute(CurrencyPickerReducer.Action)
            case recordTransactionFailureAlert(RecordTransactionFailureAlert)

            public enum RecordTransactionFailureAlert: Equatable {
                case okButtonTapped
            }
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.currencyPickerRoute, action: \.currencyPickerRoute) {
                resolve(\InvestmentFeatureContainer.currencyPickerReducer)
            }
        }
    }
}
