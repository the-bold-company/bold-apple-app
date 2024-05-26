import ComposableArchitecture
import DomainEntities
import Foundation

@Reducer
public struct CurrencyPickerReducer {
    public init() {}
    public struct State: Equatable {
        let currencies: IdentifiedArrayOf<Currency> = [
            Currency.usd,
            Currency.vnd,
        ]
        var currentlySelected: Currency

        public init(currentlySelected: Currency) {
            self.currentlySelected = currentlySelected
        }
    }

    public enum Action {
        case selectCurrency(Currency)
    }

    @Dependency(\.dismiss) var dismiss

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectCurrency(currency):
                state.currentlySelected = currency
                return .run { _ in await dismiss() }
            }
        }
    }
}

extension Currency: Identifiable {
    public var id: String {
        return code.rawValue
    }
}

extension Currency {
    static let usd = Currency(code: .unitedStatesDollar)
    static let vnd = Currency(code: .dong)
}
