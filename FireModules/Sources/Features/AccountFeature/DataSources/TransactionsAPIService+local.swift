import Combine
import ComposableArchitecture
import DomainUtilities
import Foundation

public extension TransactionsAPIService {
    static func local(
        createTransactionMockURL: URL
    ) -> Self {
        mockData(
            createTransactionMock: try? Data(contentsOf: createTransactionMockURL)
        )
    }

    static func directMock(
        createTransactionMock: String? = nil
    ) -> Self {
        mockData(
            createTransactionMock: createTransactionMock?.data(using: .utf8)
        )
    }
}

extension TransactionsAPIService {
    private static func mockData(
        createTransactionMock: Data? = nil
    ) -> Self {
        .init(
            createTransaction: { _, _, _, _, _, _, _ in
                guard let createTransactionMock else { fatalError() }
                return Effect.publisher {
                    Just(createTransactionMock)
                        .mapToResponse(TransactionAPIResponse.self, apiVersion: .v1_1)
                        .mapErrorToDomainError()
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
            }
        )
    }
}
