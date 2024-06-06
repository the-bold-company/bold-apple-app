import DomainEntities
import TemporaryPersistenceServiceInterface

public extension TemporaryPersistenceService {
    static var live: TemporaryPersistenceService {
        let persistedData = AuthenticatedUserData(loadedFunds: [])
        return TemporaryPersistenceService(
            loadedFunds: { await persistedData.loadedFunds },
            updateLoadedFunds: { await persistedData.setLoadedFunds(funds: $0) },
            cleanUp: { await persistedData.cleanUp() }
        )
    }
}
