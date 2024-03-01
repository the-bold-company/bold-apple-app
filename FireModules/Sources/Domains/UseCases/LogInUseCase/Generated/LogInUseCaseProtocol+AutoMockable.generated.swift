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

public class LogInUseCaseProtocolMock: LogInUseCaseProtocol {
    public init() {}
    //MARK: - login

    public var loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorCallsCount = 0
    public var loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorCalled: Bool {
        return loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorCallsCount > 0
    }
    public var loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReceivedArguments: (email: String, password: String)?
    public var loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReceivedInvocations: [(email: String, password: String)] = []
    public var loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue: Result<AuthenticatedUserEntity, DomainError>!
    public var loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure: ((String, String) async -> Result<AuthenticatedUserEntity, DomainError>)?

    public func login(email: String, password: String) async -> Result<AuthenticatedUserEntity, DomainError> {
        loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorCallsCount += 1
        loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReceivedArguments = (email: email, password: password)
        loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReceivedInvocations.append((email: email, password: password))
        if let loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure = loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure {
            return await loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure(email, password)
        } else {
            return loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue
        }
    }

}
// swiftlint:enable line_length
// swiftlint:enable variable_name
// swiftlint:enable large_tuple
