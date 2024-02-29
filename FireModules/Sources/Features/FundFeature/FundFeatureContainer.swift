//
//  FundFeatureContainer.swift
//
//
//  Created by Hien Tran on 27/02/2024.
//

import Factory
import FundCreationUseCase
import FundDetailsUseCase
import FundsAPIServiceInterface

public final class FundFeatureContainer: SharedContainer {
    public static let shared = FundFeatureContainer()
    public let manager = ContainerManager()
}

public extension FundFeatureContainer {
    var fundDetailsUseCase: Factory<FundDetailsUseCaseProtocol?> { self { nil } }
    var fundCreationUseCase: Factory<FundCreationUseCaseProtocol?> { self { nil } }
    var fundDetailsReducer: Factory<FundDetailsReducer?> { self { nil } }
    var fundCreationReducer: Factory<FundCreationReducer?> { self { nil } }
}
