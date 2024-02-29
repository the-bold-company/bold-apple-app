//
//  HomeFeatureContainer.swift
//
//
//  Created by Hien Tran on 28/02/2024.
//

import Factory
import FundDetailsUseCase
import FundListUseCase
import PortfolioUseCase
import TransactionListUseCase

public final class HomeFeatureContainer: SharedContainer {
    public static let shared = HomeFeatureContainer()
    public let manager = ContainerManager()
}

public extension HomeFeatureContainer {
    var transactionListUseCase: Factory<TransactionListUseCaseProtocol?> { self { nil } }
    var fundListUseCase: Factory<FundListUseCaseProtocol?> { self { nil } }
    var fundDetailsUseCase: Factory<FundDetailsUseCaseProtocol?> { self { nil } }
    var portfolioUseCase: Factory<PortfolioUseCaseInterface?> { self { nil } }
    var homeReducer: Factory<HomeReducer?> { self { nil } }
}
