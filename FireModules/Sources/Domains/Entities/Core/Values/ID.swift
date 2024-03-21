import Foundation

public struct ID: Value, Equatable, Hashable {
    public let value: Result<UUID, NeverFail>

    public var id: UUID {
        return getOrCrash()
    }

    public init(uuidString: String) {
        self.value = .success(UUID(uuidString: uuidString) ?? UUID())
    }

    public init(uuid: UUID) {
        self.value = .success(uuid)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension ID {
    static func generated() -> ID {
        return ID(uuid: UUID())
    }
}
