import Combine
import ComposableArchitecture
import DomainUtilities
import Foundation

public extension AccountsAPIService {
    static func local(
        createAccountMockURL: URL
    ) -> Self {
        mockData(
            createAccountMock: try? Data(contentsOf: createAccountMockURL)
        )
    }

    static func directMock(
        createAccountMock: String? = nil
    ) -> Self {
        mockData(
            createAccountMock: createAccountMock?.data(using: .utf8)
        )
    }
}

extension AccountsAPIService {
    private static func mockData(
        createAccountMock: Data? = nil
    ) -> Self {
        .init(
            createAccount: { _ in
                guard let createAccountMock else { fatalError() }
                return Effect.publisher {
                    Just(createAccountMock)
                        .mapToResponse(AccountAPIResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
            }
        )
    }
}
