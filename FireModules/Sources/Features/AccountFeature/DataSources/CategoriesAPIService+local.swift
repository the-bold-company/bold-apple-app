import Combine
import ComposableArchitecture
import DomainUtilities
import Foundation

public extension CategoriesAPIService {
    static func local(
        getCategoriesMockURL: URL,
        createCategoryMockURL: URL
    ) -> Self {
        mockData(
            getCategoriesMock: try? Data(contentsOf: getCategoriesMockURL),
            createCategoryMock: try? Data(contentsOf: createCategoryMockURL)
        )
    }

    static func directMock(
        getCategoriesMock: String? = nil,
        createCategoryMock: String? = nil
    ) -> Self {
        mockData(
            getCategoriesMock: getCategoriesMock?.data(using: .utf8),
            createCategoryMock: createCategoryMock?.data(using: .utf8)
        )
    }
}

extension CategoriesAPIService {
    private static func mockData(
        getCategoriesMock: Data? = nil,
        createCategoryMock: Data? = nil
    ) -> Self {
        .init(
            getCategories: { _ in
                guard let getCategoriesMock else { fatalError() }
                return Effect.publisher {
                    Just(getCategoriesMock)
                        .mapToResponse([CategoryAPIResponse].self, apiVersion: .v1_1)
                        .mapErrorToDomainError()
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
            },
            createCategory: { _, _, _ in
                guard let createCategoryMock else { fatalError() }
                return Effect.publisher {
                    Just(createCategoryMock)
                        .mapToResponse(CategoryAPIResponse.self, apiVersion: .v1_1)
                        .mapErrorToDomainError()
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
            }
        )
    }
}
