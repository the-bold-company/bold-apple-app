import ComposableArchitecture
import DomainUtilities
import Networking

public extension CategoriesAPIService {
    static var live: Self {
        let networkClient = MoyaClient<CategoriesAPI.v1>()

        return .init(
            getCategories: { transferType in
                Effect.publisher {
                    networkClient
                        .requestPublisher(.getCategories(transferType: transferType))
                        .mapToResponse([CategoryAPIResponse].self, apiVersion: .v1_1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }

            },
            createCategory: { icon, name, transferType in
                Effect.publisher {
                    networkClient
                        .requestPublisher(.createCategory(icon: icon, name: name, transferType: transferType))
                        .mapToResponse(CategoryAPIResponse.self, apiVersion: .v1_1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            }
        )
    }
}
