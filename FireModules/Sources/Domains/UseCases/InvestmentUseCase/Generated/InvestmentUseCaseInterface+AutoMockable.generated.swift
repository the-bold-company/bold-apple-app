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

    public var createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorCallsCount = 0
    public var createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorCalled: Bool {
        return createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorCallsCount > 0
    }
    public var createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReceivedName: (String)?
    public var createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReceivedInvocations: [(String)] = []
    public var createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReturnValue: Result<InvestmentPortfolioEntity, DomainError>!
    public var createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorClosure: ((String) async -> Result<InvestmentPortfolioEntity, DomainError>)?

    public func createPortfolio(name: String) async -> Result<InvestmentPortfolioEntity, DomainError> {
        createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorCallsCount += 1
        createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReceivedName = name
        createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReceivedInvocations.append(name)
        if let createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorClosure = createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorClosure {
            return await createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorClosure(name)
        } else {
            return createPortfolioNameStringResultInvestmentPortfolioEntityDomainErrorReturnValue
        }
    }

    // MARK: - getPortfolioList

    public var getPortfolioListResultInvestmentPortfolioEntityDomainErrorCallsCount = 0
    public var getPortfolioListResultInvestmentPortfolioEntityDomainErrorCalled: Bool {
        return getPortfolioListResultInvestmentPortfolioEntityDomainErrorCallsCount > 0
    }
    public var getPortfolioListResultInvestmentPortfolioEntityDomainErrorReturnValue: Result<[InvestmentPortfolioEntity], DomainError>!
    public var getPortfolioListResultInvestmentPortfolioEntityDomainErrorClosure: (() async -> Result<[InvestmentPortfolioEntity], DomainError>)?

    public func getPortfolioList() async -> Result<[InvestmentPortfolioEntity], DomainError> {
        getPortfolioListResultInvestmentPortfolioEntityDomainErrorCallsCount += 1
        if let getPortfolioListResultInvestmentPortfolioEntityDomainErrorClosure = getPortfolioListResultInvestmentPortfolioEntityDomainErrorClosure {
            return await getPortfolioListResultInvestmentPortfolioEntityDomainErrorClosure()
        } else {
            return getPortfolioListResultInvestmentPortfolioEntityDomainErrorReturnValue
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
