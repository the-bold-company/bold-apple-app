import Combine
import ComposableArchitecture
import DomainEntities
import DomainUtilities
import Foundation
import Utilities

public typealias CreateTransactionResult = Result<TransactionAPIResponse, DomainError>

public struct TransactionsAPIService {
    public var createTransaction: @Sendable (
        _ type: TransactionType,
        _ amount: Decimal,
        _ accountId: String,
        _ date: TimeInterval,
        _ categoryId: String?,
        _ name: String?,
        _ note: String?
    ) -> Effect<CreateTransactionResult>
}

public enum TransactionsAPIServiceKey: DependencyKey {
    public static let liveValue = TransactionsAPIService.live

    public static let previewValue = TransactionsAPIService.local(
        createTransactionMockURL: .local(backward: 6).appendingPathComponent("mock/account-management/v1/transactions/create/response.json")
    )

    public static let testValue = TransactionsAPIService(
        createTransaction: unimplemented("\(Self.self).createTransaction")
    )
}

public extension DependencyValues {
    var transactionsAPIService: TransactionsAPIService {
        get { self[TransactionsAPIServiceKey.self] }
        set { self[TransactionsAPIServiceKey.self] = newValue }
    }
}
