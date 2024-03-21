// swiftlint:disable line_length
// swiftlint:disable file_length

import ComposableArchitecture
@testable import InvestmentFeature
import InvestmentUseCase
import TestHelpers
import XCTest

@MainActor
final class InvestmentHomeReducerTests: XCTestCase {
    private var initialState: InvestmentHomeReducer.State!
    private var investmentUseCase: InvestmentUseCaseInterfaceMock!

    override func setUpWithError() throws {
        initialState = InvestmentHomeReducer.State()
        investmentUseCase = InvestmentUseCaseInterfaceMock()
    }

    func testOnApearAction_OnlyCallsAPI_WhenStateIsIdle() async throws {
        // Arrange
        investmentUseCase.getPortfolioListResultInvestmentPortfolioEntityDomainErrorReturnValue = .success(InvestmentPortfolioEntity.portfolioList)
        let store = TestStore(
            initialState: update(initialState) {
                $0.loadPortfoliosState = .idle
            },
            reducer: {
                InvestmentHomeReducer(investmentUseCase: investmentUseCase)
            }
        )
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.onAppear))

        // Assert
        XCAssertNoDifference(investmentUseCase.getPortfolioListResultInvestmentPortfolioEntityDomainErrorCallsCount, 1)
    }

    func testOnApearAction_NotCallingAPI_WhenStateIsLoading() async throws {
        // Arrange
        investmentUseCase.getPortfolioListResultInvestmentPortfolioEntityDomainErrorReturnValue = .success(InvestmentPortfolioEntity.portfolioList)
        let store = TestStore(
            initialState: update(initialState) {
                $0.loadPortfoliosState = .loading
            },
            reducer: {
                InvestmentHomeReducer(investmentUseCase: investmentUseCase)
            }
        )
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.onAppear))

        // Assert
        XCAssertNoDifference(investmentUseCase.getPortfolioListResultInvestmentPortfolioEntityDomainErrorCallsCount, 0)
    }

    func testOnApearAction_NotCallingAPI_WhenStateIsLoaded() async throws {
        // Arrange
        investmentUseCase.getPortfolioListResultInvestmentPortfolioEntityDomainErrorReturnValue = .success(InvestmentPortfolioEntity.portfolioList)
        let store = TestStore(
            initialState: update(initialState) {
                $0.loadPortfoliosState = .loaded(InvestmentPortfolioEntity.portfolioList)
            },
            reducer: {
                InvestmentHomeReducer(investmentUseCase: investmentUseCase)
            }
        )
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.onAppear))

        // Assert
        XCAssertNoDifference(investmentUseCase.getPortfolioListResultInvestmentPortfolioEntityDomainErrorCallsCount, 0)
    }

    func testGetPortfolioListSuccessfully() async throws {
        // Arrange
        investmentUseCase.getPortfolioListResultInvestmentPortfolioEntityDomainErrorReturnValue = .success(InvestmentPortfolioEntity.portfolioList)
        let store = TestStore(initialState: initialState, reducer: {
            InvestmentHomeReducer(investmentUseCase: investmentUseCase)
        })
        store.exhaustivity = .off

        // Act
        await store.send(.forward(.onAppear)) {
            $0.loadPortfoliosState = .loading
        }

        // Assert
        await store.receive(\.delegate.portfolioListLoaded) {
            $0.loadPortfoliosState = .loaded(InvestmentPortfolioEntity.portfolioList)
            $0.portfolioList = IdentifiedArray(uniqueElements: InvestmentPortfolioEntity.portfolioList)
        }
    }

    func testCreatePortfolioName_NameIsEmpty_MustThrowError() async throws {
        // Arrange
        let store = TestStore(initialState: initialState, reducer: {
            InvestmentHomeReducer(investmentUseCase: investmentUseCase)
        })
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.set(\.$portfolioName, ""))
        await store.send(.forward(.submitPortfolioCreationForm)) {
            $0.destination = .invalidPortfolioCreationAlert(
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
        }
    }

    func testCreatePortfolioName_NameIsLongerThan50Chars_MustThrowError() async throws {
        // Arrange

        let store = TestStore(initialState: initialState, reducer: {
            InvestmentHomeReducer(investmentUseCase: investmentUseCase)
        })
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.set(\.$portfolioName, "Lorem ipsum dolor sit amet, consectetur adipiscing elit"))
        await store.send(.forward(.submitPortfolioCreationForm)) {
            $0.destination = .invalidPortfolioCreationAlert(
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
        }
    }

    func testInvalidPortfolioCreationAlert_TapOk_DestinationMustBeSetBackToNil() async throws {
        // Arrange
        let store = TestStore(
            initialState: update(initialState) {
                $0.destination = .invalidPortfolioCreationAlert(
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
            },
            reducer: {
                InvestmentHomeReducer(investmentUseCase: investmentUseCase)
            }
        )
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.destination(.presented(.invalidPortfolioCreationAlert(.okButtonTapped)))) {
            $0.destination = nil
        }
    }

    func testCreatePortfolioNameSuccessfully() async throws {
        // Arrange
        investmentUseCase.createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReturnValue = .success(InvestmentPortfolioEntity.emptyPortfolioWithName("Lorem ipsum"))
        let store = TestStore(initialState: initialState, reducer: {
            InvestmentHomeReducer(investmentUseCase: investmentUseCase)
        })
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$portfolioName, "Lorem ipsum"))
        await store.send(.forward(.submitPortfolioCreationForm)) {
            $0.createPortfolioState = .loading
        }

        // Assert
        await store.receive(\.delegate.portfolioCreated) {
            $0.createPortfolioState = .loaded(
                InvestmentPortfolioEntity.emptyPortfolioWithName(self.investmentUseCase.createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReceivedName!)
            )
        }
    }

    func testCreatePortfolioNameFailed() async throws {
        // Arrange
        investmentUseCase.createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReturnValue = .failure(DomainError.custom(description: "Unable to create portfolio with name Lorem ipsum", reason: "Unable to create portfolio with name Lorem ipsum"))
        let store = TestStore(initialState: initialState, reducer: {
            InvestmentHomeReducer(investmentUseCase: investmentUseCase)
        })
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$portfolioName, "Lorem ipsum"))
        await store.send(.forward(.submitPortfolioCreationForm)) {
            $0.createPortfolioState = .loading
        }

        // Assert
        await store.receive(\.delegate.failedToCreatePorfolio) {
            let errorMessage = "Unable to create portfolio with name \(self.investmentUseCase.createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReceivedName!)"

            $0.createPortfolioState = .failure(
                DomainError.custom(description: errorMessage, reason: errorMessage)
            )
            $0.destination = .invalidPortfolioCreationAlert(
                AlertState {
                    TextState("Unable to create portfolio")
                } actions: {
                    ButtonState(role: .cancel, action: .okButtonTapped) {
                        TextState("Ok")
                    }
                } message: {
                    TextState(errorMessage)
                }
            )
        }
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
