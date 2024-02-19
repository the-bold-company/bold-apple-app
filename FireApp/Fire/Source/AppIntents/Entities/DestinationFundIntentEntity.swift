//
//  DestinationFundIntentEntity.swift
//  Fire
//
//  Created by Hien Tran on 19/02/2024.
//

import AppIntents
import Intents

private let noneUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

struct DestinationFundIntentEntity: AppEntity {
    let id: UUID

    @Property(title: "Name")
    var name: String

    let balance: Decimal

    var representsNull: Bool {
        return id == noneUUID
    }

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        return "Destination fund"
    }

    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: LocalizedStringResource(
                stringLiteral: name
            )
        )
    }

    static var defaultQuery = DestinationFundQuery()

    init(id: UUID, name: String, balance: Decimal) {
        self.id = id
        self.balance = balance
        self.name = name
    }
}

extension DestinationFundIntentEntity {
    static let none = DestinationFundIntentEntity(
        id: noneUUID,
        name: "None",
        balance: 0
    )
}

struct DestinationFundQuery: EntityQuery {
    let appIntentService = AppIntentService()

    func entities(for identifiers: [UUID]) async throws -> [DestinationFundIntentEntity] {
        let entities = try await loadOptions()
        return entities.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [DestinationFundIntentEntity] {
        return try await loadOptions()
    }

    func loadOptions() async throws -> [DestinationFundIntentEntity] {
        var options = [DestinationFundIntentEntity.none]
        let fundEntities = try await appIntentService.fetchFunds()
            .map { DestinationFundIntentEntity(id: $0.id, name: $0.name, balance: $0.balance) }

        options.append(contentsOf: fundEntities)
        return options
    }
}
