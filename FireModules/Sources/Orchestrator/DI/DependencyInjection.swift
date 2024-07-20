// Data layer imports
import AuthAPIService
import AuthAPIServiceInterface
import FundsAPIService
import FundsAPIServiceInterface
import InvestmentAPIService
import InvestmentAPIServiceInterface
import KeychainService
import KeychainServiceInterface
import MarketAPIService
import MarketAPIServiceInterface
import PersistenceService
import PersistenceServiceInterface
import PortfolioAPIService
import PortfolioAPIServiceInterface
import TemporaryPersistenceService
import TemporaryPersistenceServiceInterface
import TransactionsAPIService
import TransactionsAPIServiceInterface

// Domain layer imports
import AuthenticationUseCase
import DevSettingsUseCase
import FundCreationUseCase
import FundDetailsUseCase
import FundListUseCase
import InvestmentUseCase
import LiveMarketUseCase
import PortfolioUseCase
import TransactionListUseCase
import TransactionRecordUseCase

public extension Container {
    // MARK: Register data layer services

    var keychainService: Factory<KeychainServiceProtocol> {
        self { KeychainService() }
    }

    var temporaryPersistenceService: Factory<TemporaryPersistenceService> {
        self { TemporaryPersistenceService.live }.singleton
    }

    var persistenceService: Factory<PersistenceServiceInterface> {
        self { PersistenceService() }
            .onTest { PersistenceServiceInterfaceMock() }
    }

    var authAPIService: Factory<AuthAPIService> {
        self { AuthAPIService.live }
    }

    var fundAPIService: Factory<FundsAPIServiceProtocol> {
        self { FundsAPIService() }
    }

    var transactionsAPIService: Factory<TransactionsAPIServiceProtocol> {
        self { TransactionsAPIService() }
    }

    var portfolioAPIService: Factory<PortfolioAPIServiceInterface> {
        self { PortfolioAPIService() }
    }

    var investmentAPIService: Factory<InvestmentAPIServiceInterface> {
        self { InvestmentService() }
    }

    var marketAPIService: Factory<MarketAPIServiceInterface> {
        self { MarketAPIService() }
    }

    // MARK: Register use cases

    var devSettingsUseCase: Factory<DevSettingsUseCase> {
        self { DevSettingsUseCase.live }.singleton
    }

    var logInUseCase: Factory<LogInUseCase> {
        self {
            .live(
                //                authService: self.authAPIService.callAsFunction(),
//                keychainService: self.keychainService.callAsFunction()
            )
        }
    }

    var signUpUseCase: Factory<SignUpUseCase> {
        self {
            SignUpUseCase.live()
        }
    }

    var fundDetailsUseCase: Factory<FundDetailsUseCaseProtocol> {
        self { FundDetailsUseCase(fundsAPIService: self.fundAPIService.callAsFunction()) }
    }

    var fundListUseCase: Factory<FundListUseCaseProtocol> {
        self {
            FundListUseCase(
                fundsAPIService: self.fundAPIService.callAsFunction(),
                temporaryPersistenceService: self.temporaryPersistenceService.callAsFunction(),
                persistenceService: self.persistenceService.callAsFunction()
            )
        }
    }

    var fundCreationUseCase: Factory<FundCreationUseCaseProtocol> {
        self { FundCreationUseCase(fundsAPIService: self.fundAPIService.callAsFunction()) }
    }

    var transactionListUseCase: Factory<TransactionListUseCaseProtocol> {
        self { TransactionListUseCase(transactionsAPIService: self.transactionsAPIService.callAsFunction()) }
    }

    var transactionRecordUseCase: Factory<TransactionRecordUseCaseProtocol> {
        self { TransactionRecordUseCase(transactionsAPIService: self.transactionsAPIService.callAsFunction()) }
    }

    var portfolioUseCase: Factory<PortfolioUseCaseInterface> {
        self {
            PortfolioUseCase(portfolioAPIService: self.portfolioAPIService.callAsFunction())
        }
    }

    var investmentUseCase: Factory<InvestmentUseCaseInterface> {
        self {
            InvestmentUseCase(investmentAPIService: self.investmentAPIService.callAsFunction())
        }
    }

    var liveMarketUseCase: Factory<LiveMarketUseCaseInterface> {
        self {
            LiveMarketUseCase(marketAPIService: self.marketAPIService.callAsFunction())
        }
    }
}
