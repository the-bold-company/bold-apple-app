import DomainEntities

public struct TemporaryPersistenceService {
    public var loadedFunds: @Sendable () async -> [FundEntity] = { [] }
    public var updateLoadedFunds: @Sendable ([FundEntity]) async -> Void
    public var cleanUp: @Sendable () async -> Void

    public init(
        loadedFunds: @Sendable @escaping () async -> [FundEntity],
        updateLoadedFunds: @Sendable @escaping ([FundEntity]) async -> Void,
        cleanUp: @Sendable @escaping () async -> Void
    ) {
        self.loadedFunds = loadedFunds
        self.updateLoadedFunds = updateLoadedFunds
        self.cleanUp = cleanUp
    }
}
