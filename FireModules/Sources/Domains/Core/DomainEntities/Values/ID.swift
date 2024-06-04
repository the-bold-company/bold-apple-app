import Foundation

public struct ID: Value, Equatable, Hashable {
    public let value: Result<UUID, NeverFail>

    public var id: UUID {
        return getOrCrash()
    }

    /// Because Swift uses uppercased UUID string while dynamodb accepts lowercased. Use this to send to server
    public var dynamodbCompartibleUUIDString: String {
        return id.uuidString.lowercased()
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
