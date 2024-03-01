// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name
// swiftlint:disable large_tuple

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public class FundDetailsUseCaseProtocolMock: FundDetailsUseCaseProtocol {
    public init() {}
    //MARK: - loadFundDetails

    public var loadFundDetailsIdUUIDResultFundEntityDomainErrorCallsCount = 0
    public var loadFundDetailsIdUUIDResultFundEntityDomainErrorCalled: Bool {
        return loadFundDetailsIdUUIDResultFundEntityDomainErrorCallsCount > 0
    }
    public var loadFundDetailsIdUUIDResultFundEntityDomainErrorReceivedId: (UUID)?
    public var loadFundDetailsIdUUIDResultFundEntityDomainErrorReceivedInvocations: [(UUID)] = []
    public var loadFundDetailsIdUUIDResultFundEntityDomainErrorReturnValue: Result<FundEntity, DomainError>!
    public var loadFundDetailsIdUUIDResultFundEntityDomainErrorClosure: ((UUID) async -> Result<FundEntity, DomainError>)?

    public func loadFundDetails(id: UUID) async -> Result<FundEntity, DomainError> {
        loadFundDetailsIdUUIDResultFundEntityDomainErrorCallsCount += 1
        loadFundDetailsIdUUIDResultFundEntityDomainErrorReceivedId = id
        loadFundDetailsIdUUIDResultFundEntityDomainErrorReceivedInvocations.append(id)
        if let loadFundDetailsIdUUIDResultFundEntityDomainErrorClosure = loadFundDetailsIdUUIDResultFundEntityDomainErrorClosure {
            return await loadFundDetailsIdUUIDResultFundEntityDomainErrorClosure(id)
        } else {
            return loadFundDetailsIdUUIDResultFundEntityDomainErrorReturnValue
        }
    }

    //MARK: - deleteFund

    public var deleteFundIdUUIDResultUUIDDomainErrorCallsCount = 0
    public var deleteFundIdUUIDResultUUIDDomainErrorCalled: Bool {
        return deleteFundIdUUIDResultUUIDDomainErrorCallsCount > 0
    }
    public var deleteFundIdUUIDResultUUIDDomainErrorReceivedId: (UUID)?
    public var deleteFundIdUUIDResultUUIDDomainErrorReceivedInvocations: [(UUID)] = []
    public var deleteFundIdUUIDResultUUIDDomainErrorReturnValue: Result<UUID, DomainError>!
    public var deleteFundIdUUIDResultUUIDDomainErrorClosure: ((UUID) async -> Result<UUID, DomainError>)?

    public func deleteFund(id: UUID) async -> Result<UUID, DomainError> {
        deleteFundIdUUIDResultUUIDDomainErrorCallsCount += 1
        deleteFundIdUUIDResultUUIDDomainErrorReceivedId = id
        deleteFundIdUUIDResultUUIDDomainErrorReceivedInvocations.append(id)
        if let deleteFundIdUUIDResultUUIDDomainErrorClosure = deleteFundIdUUIDResultUUIDDomainErrorClosure {
            return await deleteFundIdUUIDResultUUIDDomainErrorClosure(id)
        } else {
            return deleteFundIdUUIDResultUUIDDomainErrorReturnValue
        }
    }

    //MARK: - loadTransactionHistory

    public var loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorCallsCount = 0
    public var loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorCalled: Bool {
        return loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorCallsCount > 0
    }
    public var loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorReceivedArguments: (fundId: UUID, order: SortOrder)?
    public var loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorReceivedInvocations: [(fundId: UUID, order: SortOrder)] = []
    public var loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorReturnValue: Result<PaginationEntity<TransactionEntity>, DomainError>!
    public var loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorClosure: ((UUID, SortOrder) async -> Result<PaginationEntity<TransactionEntity>, DomainError>)?

    public func loadTransactionHistory(fundId: UUID, order: SortOrder) async -> Result<PaginationEntity<TransactionEntity>, DomainError> {
        loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorCallsCount += 1
        loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorReceivedArguments = (fundId: fundId, order: order)
        loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorReceivedInvocations.append((fundId: fundId, order: order))
        if let loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorClosure = loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorClosure {
            return await loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorClosure(fundId, order)
        } else {
            return loadTransactionHistoryFundIdUUIDOrderSortOrderResultPaginationEntityTransactionEntityDomainErrorReturnValue
        }
    }

}
// swiftlint:enable line_length
// swiftlint:enable variable_name
// swiftlint:enable large_tuple
