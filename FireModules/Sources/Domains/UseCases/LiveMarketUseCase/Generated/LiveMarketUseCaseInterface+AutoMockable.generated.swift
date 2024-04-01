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

public class LiveMarketUseCaseInterfaceMock: LiveMarketUseCaseInterface {
    public init() {}
    // MARK: - convertCurrency

    public var convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityCallsCount = 0
    public var convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityCalled: Bool {
        return convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityCallsCount > 0
    }
    public var convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityReceivedArguments: (money: Money, toCurrency: Currency)?
    public var convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityReceivedInvocations: [(money: Money, toCurrency: Currency)] = []
    public var convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityReturnValue: DomainResult<CurrencyConversionEntity>!
    public var convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityClosure: ((Money, Currency) async -> DomainResult<CurrencyConversionEntity>)?

    public func convertCurrency(money: Money, to toCurrency: Currency) async -> DomainResult<CurrencyConversionEntity> {
        convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityCallsCount += 1
        convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityReceivedArguments = (money: money, toCurrency: toCurrency)
        convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityReceivedInvocations.append((money: money, toCurrency: toCurrency))
        if let convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityClosure = convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityClosure {
            return await convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityClosure(money, toCurrency)
        } else {
            return convertCurrencyMoneyMoneyToToCurrencyCurrencyDomainResultCurrencyConversionEntityReturnValue
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
