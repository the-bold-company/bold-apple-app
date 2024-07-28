import Combine
import ComposableArchitecture
import DomainEntities
import DomainUtilities
import Foundation

public typealias CreateAccountResult = Result<AccountAPIResponse, DomainError>

public struct AccountsAPIService {
    public var createAccount: @Sendable (_ data: CreateAccountBody) -> Effect<CreateAccountResult>

    public init(
        createAccount: @escaping @Sendable (_ data: CreateAccountBody) -> Effect<CreateAccountResult>
    ) {
        self.createAccount = createAccount
    }
}

public enum AccountsAPIServiceKey: DependencyKey {
    public static let liveValue = AccountsAPIService.live

    public static let testValue = AccountsAPIService(
        createAccount: unimplemented("\(Self.self).logIn")
    )
}

public extension DependencyValues {
    var accountsAPIService: AccountsAPIService {
        get { self[AccountsAPIServiceKey.self] }
        set { self[AccountsAPIServiceKey.self] = newValue }
    }
}
