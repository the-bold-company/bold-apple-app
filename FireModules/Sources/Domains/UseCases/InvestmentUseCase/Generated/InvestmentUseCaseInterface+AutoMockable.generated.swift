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

public class InvestmentUseCaseInterfaceMock: InvestmentUseCaseInterface {
    public init() {}
    // MARK: - createPortfolio

    public var createPortfolioNameStringDomainResultInvestmentPortfolioEntityCallsCount = 0
    public var createPortfolioNameStringDomainResultInvestmentPortfolioEntityCalled: Bool {
        return createPortfolioNameStringDomainResultInvestmentPortfolioEntityCallsCount > 0
    }
    public var createPortfolioNameStringDomainResultInvestmentPortfolioEntityReceivedName: (String)?
    public var createPortfolioNameStringDomainResultInvestmentPortfolioEntityReceivedInvocations: [(String)] = []
    public var createPortfolioNameStringDomainResultInvestmentPortfolioEntityReturnValue: DomainResult<InvestmentPortfolioEntity>!
    public var createPortfolioNameStringDomainResultInvestmentPortfolioEntityClosure: ((String) async -> DomainResult<InvestmentPortfolioEntity>)?

    public func createPortfolio(name: String) async -> DomainResult<InvestmentPortfolioEntity> {
        createPortfolioNameStringDomainResultInvestmentPortfolioEntityCallsCount += 1
        createPortfolioNameStringDomainResultInvestmentPortfolioEntityReceivedName = name
        createPortfolioNameStringDomainResultInvestmentPortfolioEntityReceivedInvocations.append(name)
        if let createPortfolioNameStringDomainResultInvestmentPortfolioEntityClosure = createPortfolioNameStringDomainResultInvestmentPortfolioEntityClosure {
            return await createPortfolioNameStringDomainResultInvestmentPortfolioEntityClosure(name)
        } else {
            return createPortfolioNameStringDomainResultInvestmentPortfolioEntityReturnValue
        }
    }

    // MARK: - getPortfolioList

    public var getPortfolioListDomainResultInvestmentPortfolioEntityCallsCount = 0
    public var getPortfolioListDomainResultInvestmentPortfolioEntityCalled: Bool {
        return getPortfolioListDomainResultInvestmentPortfolioEntityCallsCount > 0
    }
    public var getPortfolioListDomainResultInvestmentPortfolioEntityReturnValue: DomainResult<[InvestmentPortfolioEntity]>!
    public var getPortfolioListDomainResultInvestmentPortfolioEntityClosure: (() async -> DomainResult<[InvestmentPortfolioEntity]>)?

    public func getPortfolioList() async -> DomainResult<[InvestmentPortfolioEntity]> {
        getPortfolioListDomainResultInvestmentPortfolioEntityCallsCount += 1
        if let getPortfolioListDomainResultInvestmentPortfolioEntityClosure = getPortfolioListDomainResultInvestmentPortfolioEntityClosure {
            return await getPortfolioListDomainResultInvestmentPortfolioEntityClosure()
        } else {
            return getPortfolioListDomainResultInvestmentPortfolioEntityReturnValue
        }
    }

    // MARK: - recordTransaction

    public var recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityCallsCount = 0
    public var recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityCalled: Bool {
        return recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityCallsCount > 0
    }
    public var recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReceivedArguments: (amount: Decimal, portfolioId: ID, type: String, currency: String, notes: String?)?
    public var recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReceivedInvocations: [(amount: Decimal, portfolioId: ID, type: String, currency: String, notes: String?)] = []
    public var recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReturnValue: DomainResult<InvestmentTransactionEntity>!
    public var recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityClosure: ((Decimal, ID, String, String, String?) async -> DomainResult<InvestmentTransactionEntity>)?

    public func recordTransaction(amount: Decimal, portfolioId: ID, type: String, currency: String, notes: String?) async -> DomainResult<InvestmentTransactionEntity> {
        recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityCallsCount += 1
        recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReceivedArguments = (amount: amount, portfolioId: portfolioId, type: type, currency: currency, notes: notes)
        recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReceivedInvocations.append((amount: amount, portfolioId: portfolioId, type: type, currency: currency, notes: notes))
        if let recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityClosure = recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityClosure {
            return await recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityClosure(amount, portfolioId, type, currency, notes)
        } else {
            return recordTransactionAmountDecimalPortfolioIdIDTypeStringCurrencyStringNotesStringDomainResultInvestmentTransactionEntityReturnValue
        }
    }

    // MARK: - getPortfolioDetails

    public var getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityCallsCount = 0
    public var getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityCalled: Bool {
        return getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityCallsCount > 0
    }
    public var getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityReceivedId: (String)?
    public var getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityReceivedInvocations: [(String)] = []
    public var getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityReturnValue: DomainResult<InvestmentPortfolioEntity>!
    public var getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityClosure: ((String) async -> DomainResult<InvestmentPortfolioEntity>)?

    public func getPortfolioDetails(id: String) async -> DomainResult<InvestmentPortfolioEntity> {
        getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityCallsCount += 1
        getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityReceivedId = id
        getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityReceivedInvocations.append(id)
        if let getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityClosure = getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityClosure {
            return await getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityClosure(id)
        } else {
            return getPortfolioDetailsIdStringDomainResultInvestmentPortfolioEntityReturnValue
        }
    }

    // MARK: - getTransactionHistory

    public var getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityCallsCount = 0
    public var getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityCalled: Bool {
        return getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityCallsCount > 0
    }
    public var getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityReceivedPortfolioId: (ID)?
    public var getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityReceivedInvocations: [(ID)] = []
    public var getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityReturnValue: DomainResult<[InvestmentTransactionEntity]>!
    public var getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityClosure: ((ID) async -> DomainResult<[InvestmentTransactionEntity]>)?

    public func getTransactionHistory(portfolioId: ID) async -> DomainResult<[InvestmentTransactionEntity]> {
        getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityCallsCount += 1
        getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityReceivedPortfolioId = portfolioId
        getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityReceivedInvocations.append(portfolioId)
        if let getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityClosure = getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityClosure {
            return await getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityClosure(portfolioId)
        } else {
            return getTransactionHistoryPortfolioIdIDDomainResultInvestmentTransactionEntityReturnValue
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
