//
//  PersistentService.swift
//
//
//  Created by Hien Tran on 10/02/2024.
//

import Dependencies
import Foundation
import RealmSwift
import SharedModels

public extension DependencyValues {
    var persistentSerivce: PersistentService {
        get { self[PersistentService.self] }
        set { self[PersistentService.self] = newValue }
    }
}

extension PersistentService: DependencyKey {
    public static var liveValue = PersistentService()
}

public class PersistentService {
    private var realm: Realm {
        get async throws {
            let _realm = try await Realm(actor: RealmActor.shared)
            return _realm
        }
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
        return try await realm
            .objects(RealmFundEntity.self)
            .map { $0.asFundEntity() }
    }
}
