import Foundation

public struct SymbolDisplayEntity: AssetEntityType {
    public let symbol: Symbol
    public let instrumentName: String

    public init(symbol: Symbol, instrumentName: String) {
        self.symbol = symbol
        self.instrumentName = instrumentName
    }
}

extension SymbolDisplayEntity: Comparable {
    public static func < (lhs: SymbolDisplayEntity, rhs: SymbolDisplayEntity) -> Bool {
        return lhs.symbol < rhs.symbol
    }
}
