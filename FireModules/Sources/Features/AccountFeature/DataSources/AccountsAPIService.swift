import Combine
import ComposableArchitecture
import DomainEntities
import DomainUtilities
import Foundation
import Utilities

public typealias CreateAccountResult = Result<AccountAPIResponse, DomainError>
public typealias GetAccountListResult = Result<[AccountAPIResponse], DomainError>

public struct AccountsAPIService {
    public var createAccount: @Sendable (_ data: CreateAccountBody) -> Effect<CreateAccountResult>
    public var getAccountList: @Sendable () -> Effect<GetAccountListResult>

    public init(
        createAccount: @escaping @Sendable (_ data: CreateAccountBody) -> Effect<CreateAccountResult>,
        getAccountList: @escaping @Sendable () -> Effect<GetAccountListResult>
    ) {
        self.createAccount = createAccount
        self.getAccountList = getAccountList
    }
}

public enum AccountsAPIServiceKey: DependencyKey {
    public static let liveValue = AccountsAPIService.live

//    public static let previewValue = AccountsAPIService.local(
//        createAccountMockURL: .local(backward: 6).appendingPathComponent("mock/account-management/v1/accounts/create/response.json"),
//        getAccountListURL: .local(backward: 6).appendingPathComponent("mock/account-management/v1/accounts/getAccountList/response.json")
//    )

    public static let testValue = AccountsAPIService(
        createAccount: unimplemented("\(Self.self).logIn"),
        getAccountList: unimplemented("\(Self.self).getAccountList")
    )
}

public extension DependencyValues {
    var accountsAPIService: AccountsAPIService {
        get { self[AccountsAPIServiceKey.self] }
        set { self[AccountsAPIServiceKey.self] = newValue }
    }
}
