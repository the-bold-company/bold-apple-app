//
//  SourceFundIntentEntity.swift
//  Fire
//
//  Created by Hien Tran on 19/02/2024.
//

import AppIntents
import Intents

struct SourceFundIntentEntity: AppEntity {
    let id: UUID

    @Property(title: "Name")
    var name: String

    let balance: Decimal

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        return "Source fund"
    }

    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: LocalizedStringResource(
                stringLiteral: name
            )
        )
    }

    static var defaultQuery = SourceFundQuery()

    init(id: UUID, name: String, balance: Decimal) {
        self.id = id
        self.balance = balance
        self.name = name
    }
}

struct SourceFundQuery: EntityQuery {
    let appIntentService = AppIntentService()

    func entities(for identifiers: [UUID]) async throws -> [SourceFundIntentEntity] {
        let entities = try await appIntentService
            .fetchFunds()
            .map { SourceFundIntentEntity(id: $0.id, name: $0.name, balance: $0.balance) }

        return entities.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [SourceFundIntentEntity] {
        return try await appIntentService
            .fetchFunds()
            .map { SourceFundIntentEntity(id: $0.id, name: $0.name, balance: $0.balance) }
    }
}
