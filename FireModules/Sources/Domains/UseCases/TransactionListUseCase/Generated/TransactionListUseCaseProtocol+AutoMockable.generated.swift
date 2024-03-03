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

public class TransactionListUseCaseProtocolMock: TransactionListUseCaseProtocol {
    public init() {}
    // MARK: - getInOutTransactions

    public var getInOutTransactionsResultTransactionEntityDomainErrorCallsCount = 0
    public var getInOutTransactionsResultTransactionEntityDomainErrorCalled: Bool {
        return getInOutTransactionsResultTransactionEntityDomainErrorCallsCount > 0
    }
    public var getInOutTransactionsResultTransactionEntityDomainErrorReturnValue: Result<[TransactionEntity], DomainError>!
    public var getInOutTransactionsResultTransactionEntityDomainErrorClosure: (() async -> Result<[TransactionEntity], DomainError>)?

    public func getInOutTransactions() async -> Result<[TransactionEntity], DomainError> {
        getInOutTransactionsResultTransactionEntityDomainErrorCallsCount += 1
        if let getInOutTransactionsResultTransactionEntityDomainErrorClosure = getInOutTransactionsResultTransactionEntityDomainErrorClosure {
            return await getInOutTransactionsResultTransactionEntityDomainErrorClosure()
        } else {
            return getInOutTransactionsResultTransactionEntityDomainErrorReturnValue
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
