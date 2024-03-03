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

import PersistenceServiceInterface
import DomainEntities
public class PersistenceServiceInterfaceMock: PersistenceServiceInterface {
    public init() {}
    // MARK: - saveFund

    public var saveFundFundFundEntityVoidThrowableError: (any Error)?
    public var saveFundFundFundEntityVoidCallsCount = 0
    public var saveFundFundFundEntityVoidCalled: Bool {
        return saveFundFundFundEntityVoidCallsCount > 0
    }
    public var saveFundFundFundEntityVoidReceivedFund: (FundEntity)?
    public var saveFundFundFundEntityVoidReceivedInvocations: [(FundEntity)] = []
    public var saveFundFundFundEntityVoidClosure: ((FundEntity) async throws -> Void)?

    public func saveFund(_ fund: FundEntity) async throws {
        saveFundFundFundEntityVoidCallsCount += 1
        saveFundFundFundEntityVoidReceivedFund = fund
        saveFundFundFundEntityVoidReceivedInvocations.append(fund)
        if let error = saveFundFundFundEntityVoidThrowableError {
            throw error
        }
        try await saveFundFundFundEntityVoidClosure?(fund)
    }

    // MARK: - saveFunds

    public var saveFundsFundsFundEntityVoidThrowableError: (any Error)?
    public var saveFundsFundsFundEntityVoidCallsCount = 0
    public var saveFundsFundsFundEntityVoidCalled: Bool {
        return saveFundsFundsFundEntityVoidCallsCount > 0
    }
    public var saveFundsFundsFundEntityVoidReceivedFunds: ([FundEntity])?
    public var saveFundsFundsFundEntityVoidReceivedInvocations: [([FundEntity])] = []
    public var saveFundsFundsFundEntityVoidClosure: (([FundEntity]) async throws -> Void)?

    public func saveFunds(_ funds: [FundEntity]) async throws {
        saveFundsFundsFundEntityVoidCallsCount += 1
        saveFundsFundsFundEntityVoidReceivedFunds = funds
        saveFundsFundsFundEntityVoidReceivedInvocations.append(funds)
        if let error = saveFundsFundsFundEntityVoidThrowableError {
            throw error
        }
        try await saveFundsFundsFundEntityVoidClosure?(funds)
    }

    // MARK: - fetchFundList

    public var fetchFundListFundEntityThrowableError: (any Error)?
    public var fetchFundListFundEntityCallsCount = 0
    public var fetchFundListFundEntityCalled: Bool {
        return fetchFundListFundEntityCallsCount > 0
    }
    public var fetchFundListFundEntityReturnValue: [FundEntity]!
    public var fetchFundListFundEntityClosure: (() async throws -> [FundEntity])?

    public func fetchFundList() async throws -> [FundEntity] {
        fetchFundListFundEntityCallsCount += 1
        if let error = fetchFundListFundEntityThrowableError {
            throw error
        }
        if let fetchFundListFundEntityClosure = fetchFundListFundEntityClosure {
            return try await fetchFundListFundEntityClosure()
        } else {
            return fetchFundListFundEntityReturnValue
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
