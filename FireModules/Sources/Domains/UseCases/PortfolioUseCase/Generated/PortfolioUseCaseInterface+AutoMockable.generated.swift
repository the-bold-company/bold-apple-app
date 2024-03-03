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

public class PortfolioUseCaseInterfaceMock: PortfolioUseCaseInterface {
    public init() {}
    // MARK: - getNetworth

    public var getNetworthResultNetworthEntityDomainErrorCallsCount = 0
    public var getNetworthResultNetworthEntityDomainErrorCalled: Bool {
        return getNetworthResultNetworthEntityDomainErrorCallsCount > 0
    }
    public var getNetworthResultNetworthEntityDomainErrorReturnValue: Result<NetworthEntity, DomainError>!
    public var getNetworthResultNetworthEntityDomainErrorClosure: (() async -> Result<NetworthEntity, DomainError>)?

    public func getNetworth() async -> Result<NetworthEntity, DomainError> {
        getNetworthResultNetworthEntityDomainErrorCallsCount += 1
        if let getNetworthResultNetworthEntityDomainErrorClosure = getNetworthResultNetworthEntityDomainErrorClosure {
            return await getNetworthResultNetworthEntityDomainErrorClosure()
        } else {
            return getNetworthResultNetworthEntityDomainErrorReturnValue
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
