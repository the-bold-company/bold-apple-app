public protocol AssetEntityType: Identifiable, Equatable {
    var symbol: Symbol { get }
    var instrumentName: String { get }
}

public extension AssetEntityType {
    var id: Symbol {
        return symbol
    }
}
