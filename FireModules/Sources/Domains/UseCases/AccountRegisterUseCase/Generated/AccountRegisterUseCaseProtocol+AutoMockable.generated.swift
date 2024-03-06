// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable superfluous_disable_command
// swiftlint:disable line_length
// swiftlint:disable variable_name
// swiftlint:disable large_tuple
// swiftlint:disable comment_spacing
// swiftlint:disable shorthand_optional_binding
// swiftlint:disable vertical_whitespace


import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public class AccountRegisterUseCaseProtocolMock: AccountRegisterUseCaseProtocol {
    public init() {}
    // MARK: - registerAccount

    public var registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorCallsCount = 0
    public var registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorCalled: Bool {
        return registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorCallsCount > 0
    }
    public var registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReceivedArguments: (email: String, password: String)?
    public var registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReceivedInvocations: [(email: String, password: String)] = []
    public var registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue: Result<AuthenticatedUserEntity, DomainError>!
    public var registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure: ((String, String) async -> Result<AuthenticatedUserEntity, DomainError>)?

    public func registerAccount(email: String, password: String) async -> Result<AuthenticatedUserEntity, DomainError> {
        registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorCallsCount += 1
        registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReceivedArguments = (email: email, password: password)
        registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReceivedInvocations.append((email: email, password: password))
        if let registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure = registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure {
            return await registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure(email, password)
        } else {
            return registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue
        }
    }

}
// swiftlint:enable line_length
// swiftlint:enable variable_name
// swiftlint:enable large_tuple
// swiftlint:enable comment_spacing
// swiftlint:enable shorthand_optional_binding
// swiftlint:enable vertical_whitespace
// swiftlint:enable superfluous_disable_command
