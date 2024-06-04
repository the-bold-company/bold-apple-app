import Foundation

public struct IdentifiableWrapper<Item>: Identifiable {
    public let id: UUID
    public let value: Item

    public init(value: Item) {
        self.id = UUID()
        self.value = value
    }
}
