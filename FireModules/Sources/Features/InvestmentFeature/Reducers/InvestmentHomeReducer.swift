import ComposableArchitecture
import Factory
import Foundation
import InvestmentUseCase
import SwiftUI
import Utilities

@Reducer
public struct InvestmentHomeReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?
        @BindingState var portfolioName: String = ""

        var createPortfolioState: LoadingState<InvestmentPortfolioEntity> = .idle
        var loadPortfoliosState: LoadingState<[InvestmentPortfolioEntity]> = .idle
        var portfolioList: IdentifiedArrayOf<InvestmentPortfolioEntity> = []
        public init() {}
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum Forward {
            case onAppear
            case submitPortfolioCreationForm
        }

        @CasePathable
        public enum Delegate {
            case portfolioListLoaded([InvestmentPortfolioEntity])
            case failedToLoadPortfolioList(DomainError)
            case portfolioCreated(InvestmentPortfolioEntity)
            case failedToCreatePorfolio(DomainError)
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
                guard state.loadPortfoliosState == .idle else { return .none }
                return loadPortfolioList(state: &state)
            case .forward(.submitPortfolioCreationForm):
                guard state.portfolioName.isNotEmpty, state.portfolioName.count <= 50 else {
                    state.destination = .invalidPortfolioCreationAlert(
                        AlertState {
                            TextState("Please enter a valid portfolio name")
                        } actions: {
                            ButtonState(role: .cancel, action: .okButtonTapped) {
                                TextState("Ok")
                            }
                        } message: {
                            TextState("Portfolio name must be between 0 and 50 characters")
                        }
                    )

                    return .none
                }

                state.createPortfolioState = .loading

                return .run { [name = state.portfolioName] send in
                    let result = await investmentUseCase.createPortfolio(name: name)
                    switch result {
                    case let .success(createdPortfolio):
                        await send(.delegate(.portfolioCreated(createdPortfolio)))
                    case let .failure(error):
                        await send(.delegate(.failedToCreatePorfolio(error)))
                    }
                }
            case let .delegate(.portfolioCreated(portfolio)):
                state.createPortfolioState = .loaded(portfolio)
                state.destination = .portfolioDetailsRoute(.init(portfolio: portfolio))
                return loadPortfolioList(state: &state)
            case let .delegate(.failedToCreatePorfolio(error)):
                state.createPortfolioState = .failure(error)
                state.destination = .invalidPortfolioCreationAlert(
                    AlertState {
                        TextState("Unable to create portfolio")
                    } actions: {
                        ButtonState(role: .cancel, action: .okButtonTapped) {
                            TextState("Ok")
                        }
                    } message: {
                        TextState(error.failureReason ?? "Please try again later")
                    }
                )

                return .none
            case let .delegate(.portfolioListLoaded(portfolios)):
                state.loadPortfoliosState = .loaded(portfolios)
                state.portfolioList = IdentifiedArray(uniqueElements: portfolios)
                return .none
            case let .delegate(.failedToLoadPortfolioList(error)):
                state.loadPortfoliosState = .failure(error)
                return .none
            case .destination(.presented(.invalidPortfolioCreationAlert(.okButtonTapped))):
                state.destination = nil
                return .none
            case .binding, .destination, .delegate:
                return .none
            }
        }
    }

    private func loadPortfolioList(state: inout State) -> Effect<Action> {
        guard state.loadPortfoliosState != .loading else { return .none }

        state.loadPortfoliosState = .loading
        return .run { send in
            let result = await investmentUseCase.getPortfolioList()
            switch result {
            case let .success(portfolios):
                await send(.delegate(.portfolioListLoaded(portfolios)))
            case let .failure(error):
                await send(.delegate(.failedToLoadPortfolioList(error)))
            }
        }
    }
}

// MARK: - Destination

public extension InvestmentHomeReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case invalidPortfolioCreationAlert(AlertState<Action.InvalidPortfolioCreationAlert>)
            case portfolioDetailsRoute(InvestmentPortfolioReducer.State)
        }

        public enum Action {
            case invalidPortfolioCreationAlert(InvalidPortfolioCreationAlert)
            case portfolioDetailsRoute(InvestmentPortfolioReducer.Action)

            public enum InvalidPortfolioCreationAlert: Equatable {
                case okButtonTapped
            }
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.portfolioDetailsRoute, action: \.portfolioDetailsRoute) {
                resolve(\InvestmentFeatureContainer.investmentPortfolioReducer)
            }
        }
    }
}
