import ComposableArchitecture
import DomainUtilities
import Networking

public extension AccountsAPIService {
    static var live: Self {
        let networkClient = MoyaClient<AccountsAPI.v1>()
        return .init(
            createAccount: { data in
                Effect.publisher {
                    networkClient
                        .requestPublisher(.createAccount(data))
                        .mapToResponse(AccountAPIResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            }
        )
    }
}
