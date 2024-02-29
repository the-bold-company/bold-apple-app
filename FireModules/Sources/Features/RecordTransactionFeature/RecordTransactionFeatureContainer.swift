//
//  RecordTransactionFeatureContainer.swift
//
//
//  Created by Hien Tran on 27/02/2024.
//

import Factory
import FundListUseCase
import TransactionRecordUseCase

public final class RecordTransactionFeatureContainer: SharedContainer {
    public static let shared = RecordTransactionFeatureContainer()
    public let manager = ContainerManager()
}

public extension RecordTransactionFeatureContainer {
    var transactionRecordUseCase: Factory<TransactionRecordUseCaseProtocol?> { self { nil } }
    var fundListUseCase: Factory<FundListUseCaseProtocol?> { self { nil } }
    var sendMoneyReducer: Factory<SendMoneyReducer?> { self { nil } }
}
