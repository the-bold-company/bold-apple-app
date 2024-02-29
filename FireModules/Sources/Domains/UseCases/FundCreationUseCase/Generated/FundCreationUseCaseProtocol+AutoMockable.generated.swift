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

public class FundCreationUseCaseProtocolMock: FundCreationUseCaseProtocol {
    public init() {}
    //MARK: - createFiatFund

    public var createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorCallsCount = 0
    public var createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorCalled: Bool {
        return createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorCallsCount > 0
    }
    public var createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReceivedArguments: (name: String, balance: Decimal, currency: String, description: String?)?
    public var createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReceivedInvocations: [(name: String, balance: Decimal, currency: String, description: String?)] = []
    public var createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReturnValue: Result<FundEntity, DomainError>!
    public var createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorClosure: ((String, Decimal, String, String?) async -> Result<FundEntity, DomainError>)?

    public func createFiatFund(name: String, balance: Decimal, currency: String, description: String?) async -> Result<FundEntity, DomainError> {
        createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorCallsCount += 1
        createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReceivedArguments = (name: name, balance: balance, currency: currency, description: description)
        createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReceivedInvocations.append((name: name, balance: balance, currency: currency, description: description))
        if let createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorClosure = createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorClosure {
            return await createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorClosure(name, balance, currency, description)
        } else {
            return createFiatFundNameStringBalanceDecimalCurrencyStringDescriptionStringResultFundEntityDomainErrorReturnValue
        }
    }

}
// swiftlint:enable line_length
// swiftlint:enable variable_name
// swiftlint:enable large_tuple
