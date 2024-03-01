import FundsAPIServiceInterface
import PersistenceServiceInterface
import TemporaryPersistenceServiceInterface

public struct FundListUseCase: FundListUseCaseProtocol {
    let fundsAPIService: FundsAPIServiceProtocol
    let temporaryPersistenceService: TemporaryPersistenceService
    let persistenceService: PersistenceServiceInterface

    public init(
        fundsAPIService: FundsAPIServiceProtocol,
        temporaryPersistenceService: TemporaryPersistenceService,
        persistenceService: PersistenceServiceInterface
    ) {
        self.fundsAPIService = fundsAPIService
        self.temporaryPersistenceService = temporaryPersistenceService
        self.persistenceService = persistenceService
    }

    public func getFiatFundList() async -> Result<[FundEntity], DomainError> {
        do {
            var fundList: [FundEntity]
            let temporaryCache = await temporaryPersistenceService.loadedFunds()

            if !temporaryCache.isEmpty {
                fundList = temporaryCache
            } else {
                let fromServer = try await fundsAPIService.listFunds()
                fundList = fromServer
                await temporaryPersistenceService.updateLoadedFunds(fromServer)
                // try await persistenceService.saveFunds(fromServer) // TODO: Temporary disable this for now. Doing this introduces a bug where funds data of a newly-authenticated user will override the previously-authenticated user. We need to authenticate the data on Realm first
            }
            return .success(fundList)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
