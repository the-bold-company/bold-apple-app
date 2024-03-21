//
//  DependencyInjection.swift
//
//
//  Created by Hien Tran on 24/02/2024.
//

// Data layer imports
import AuthAPIService
import AuthAPIServiceInterface
import FundsAPIService
import FundsAPIServiceInterface
import InvestmentAPIService
import InvestmentAPIServiceInterface
import KeychainService
import KeychainServiceInterface
import PersistenceService
import PersistenceServiceInterface
import PortfolioAPIService
import PortfolioAPIServiceInterface
import TemporaryPersistenceService
import TemporaryPersistenceServiceInterface
import TransactionsAPIService
import TransactionsAPIServiceInterface

// Domain layer imports
import AccountRegisterUseCase
import DevSettingsUseCase
import FundCreationUseCase
import FundDetailsUseCase
import FundListUseCase
import InvestmentUseCase
import LogInUseCase
import PortfolioUseCase
import TransactionListUseCase
import TransactionRecordUseCase

public extension Container {
    // MARK: Register data layer services

    var keychainService: Factory<KeychainServiceProtocol> {
        self { KeychainService() }
    }

    var authAPIService: Factory<AuthAPIServiceProtocol> {
        self { AuthAPIService() }
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

    var temporaryPersistenceService: Factory<TemporaryPersistenceService> {
        self { TemporaryPersistenceService.live }.singleton
    }

    var persistenceService: Factory<PersistenceServiceInterface> {
        self { PersistenceService() }
            .onTest { PersistenceServiceInterfaceMock() }
    }

    // MARK: Register use cases

    var logInUseCase: Factory<LogInUseCaseProtocol> {
        self { LogInUseCase(authService: self.authAPIService.callAsFunction(), keychainService: self.keychainService.callAsFunction()) }
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

    var accountRegisterUseCase: Factory<AccountRegisterUseCaseProtocol> {
        self { AccountRegisterUseCase(authService: self.authAPIService.callAsFunction(), keychainService: self.keychainService.callAsFunction()) }
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

    var devSettingsUseCase: Factory<DevSettingsUseCase> {
        self { DevSettingsUseCase.live }.singleton
    }
}
