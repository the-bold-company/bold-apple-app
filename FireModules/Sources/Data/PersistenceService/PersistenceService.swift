import DomainEntities
import PersistenceServiceInterface
import RealmSwift

public struct PersistenceService: PersistenceServiceInterface {
    private var realm: Realm {
        get async throws {
            let _realm = try await Realm(
                configuration: configuration,
                actor: RealmActor.shared
            )

            return _realm
        }
    }

    private var configuration: Realm.Configuration {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 0
        return config
    }

    public init() {}

    @RealmActor
    public func saveFund(_ fund: FundEntity) async throws {
        let _realm = try await realm
        try await _realm.asyncWrite {
            _realm.add(RealmFundEntity(fromFundEntity: fund), update: .modified)
        }
    }

    @RealmActor
    public func saveFunds(_ funds: [FundEntity]) async throws {
        let _realm = try await realm

        try await _realm.asyncWrite {
            _realm.add(funds.map { RealmFundEntity(fromFundEntity: $0) }, update: .modified)
        }
    }

    @RealmActor
    public func fetchFundList() async throws -> [FundEntity] {
        let _realm = try await realm

        return _realm
            .objects(RealmFundEntity.self)
            .map { $0.asFundEntity() }
    }
}
