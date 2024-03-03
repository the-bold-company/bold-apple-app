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

public class FundListUseCaseProtocolMock: FundListUseCaseProtocol {
    public init() {}
    // MARK: - getFiatFundList

    public var getFiatFundListResultFundEntityDomainErrorCallsCount = 0
    public var getFiatFundListResultFundEntityDomainErrorCalled: Bool {
        return getFiatFundListResultFundEntityDomainErrorCallsCount > 0
    }
    public var getFiatFundListResultFundEntityDomainErrorReturnValue: Result<[FundEntity], DomainError>!
    public var getFiatFundListResultFundEntityDomainErrorClosure: (() async -> Result<[FundEntity], DomainError>)?

    public func getFiatFundList() async -> Result<[FundEntity], DomainError> {
        getFiatFundListResultFundEntityDomainErrorCallsCount += 1
        if let getFiatFundListResultFundEntityDomainErrorClosure = getFiatFundListResultFundEntityDomainErrorClosure {
            return await getFiatFundListResultFundEntityDomainErrorClosure()
        } else {
            return getFiatFundListResultFundEntityDomainErrorReturnValue
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
