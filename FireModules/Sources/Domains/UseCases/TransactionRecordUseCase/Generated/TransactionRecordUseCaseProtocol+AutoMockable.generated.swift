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

public class TransactionRecordUseCaseProtocolMock: TransactionRecordUseCaseProtocol {
    public init() {}
    // MARK: - recordInOutTransaction

    public var recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorCallsCount = 0
    public var recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorCalled: Bool {
        return recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorCallsCount > 0
    }
    public var recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorReceivedArguments: (sourceFundId: UUID, amount: Decimal, destinationFundId: UUID?, description: String?)?
    public var recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorReceivedInvocations: [(sourceFundId: UUID, amount: Decimal, destinationFundId: UUID?, description: String?)] = []
    public var recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorReturnValue: Result<TransactionEntity, DomainError>!
    public var recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorClosure: ((UUID, Decimal, UUID?, String?) async -> Result<TransactionEntity, DomainError>)?

    public func recordInOutTransaction(sourceFundId: UUID, amount: Decimal, destinationFundId: UUID?, description: String?) async -> Result<TransactionEntity, DomainError> {
        recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorCallsCount += 1
        recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorReceivedArguments = (sourceFundId: sourceFundId, amount: amount, destinationFundId: destinationFundId, description: description)
        recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorReceivedInvocations.append((sourceFundId: sourceFundId, amount: amount, destinationFundId: destinationFundId, description: description))
        if let recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorClosure = recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorClosure {
            return await recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorClosure(sourceFundId, amount, destinationFundId, description)
        } else {
            return recordInOutTransactionSourceFundIdUUIDAmountDecimalDestinationFundIdUUIDDescriptionStringResultTransactionEntityDomainErrorReturnValue
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
