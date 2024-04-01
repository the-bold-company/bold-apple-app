import DomainEntities
import Foundation

// sourcery: AutoMockable
public protocol LiveMarketUseCaseInterface {
    func convertCurrency(money: Money, to toCurrency: Currency) async -> DomainResult<CurrencyConversionEntity>
}
