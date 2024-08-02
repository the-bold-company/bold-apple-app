import Combine
import ComposableArchitecture
import DomainUtilities
import Foundation

public extension AccountsAPIService {
    static func local(
        createAccountMockURL: URL,
        getAccountListURL: URL
    ) -> Self {
        mockData(
            createAccountMock: try? Data(contentsOf: createAccountMockURL),
            getAccountListMock: try? Data(contentsOf: getAccountListURL)
        )
    }

    static func directMock(
        createAccountMock: String? = nil,
        getAccountListMock: String? = nil
    ) -> Self {
        mockData(
            createAccountMock: createAccountMock?.data(using: .utf8),
            getAccountListMock: getAccountListMock?.data(using: .utf8)
        )
    }
}

extension AccountsAPIService {
    private static func mockData(
        createAccountMock: Data? = nil,
        getAccountListMock: Data? = nil
    ) -> Self {
        .init(
            createAccount: { _ in
                guard let createAccountMock else { fatalError() }
                return Effect.publisher {
                    Just(createAccountMock)
                        .mapToResponse(AccountAPIResponse.self, apiVersion: .v1_1)
                        .mapErrorToDomainError()
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
            },
            getAccountList: {
                guard let getAccountListMock else { fatalError() }
                return Effect.publisher {
                    Just(getAccountListMock)
                        .mapToResponse([AccountAPIResponse].self, apiVersion: .v1_1)
                        .mapErrorToDomainError()
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
            }
        )
    }
}
