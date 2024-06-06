//
//  TransactionEntity+Mock.swift
//
//
//  Created by Hien Tran on 03/03/2024.
//

import DomainEntities

public extension TransactionEntity {
    static var inoutLists5: [TransactionEntity] {
        [
            TransactionEntity(
                id: "e8543567-fcda-4e85-a185-79762fa971ca",
                timestamp: 1_709_372_124,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                destinationFundId: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
            TransactionEntity(
                id: "aad4297b-63f4-425b-a76c-baa6b94ff12b",
                timestamp: 1_709_372_129,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                destinationFundId: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
            TransactionEntity(
                id: "f373c0a9-75d2-4387-967a-ab05a75b6bcc",
                timestamp: 1_709_372_159,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
            TransactionEntity(
                id: "534fedb2-322e-423b-a79a-9431d8053295",
                timestamp: 1_709_372_179,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
            TransactionEntity(
                id: "f834135d-8020-418d-b6aa-8c41bbf44f4e",
                timestamp: 1_709_372_189,
                sourceFundId: "5cee8366-72e6-4372-be23-4e54aafa84a6",
                amount: 100_000,
                type: "inout",
                userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
                currency: "VND"
            ),
        ]
    }

    static let transfer = TransactionEntity(
        id: "4b295da6-e8fd-43a7-b1c9-c7103a15abb0",
        timestamp: 1_709_372_124,
        sourceFundId: "d8394718-9e23-4680-a30c-2a0b14efd695",
        destinationFundId: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
        amount: 100_000,
        type: "inout",
        userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
        currency: "VND"
    )

    static let spend = TransactionEntity(
        id: "86df35dd-be8a-4b10-bd8d-cfdac2b4c238",
        timestamp: 1_709_372_124,
        sourceFundId: "d8394718-9e23-4680-a30c-2a0b14efd695",
        amount: 100_000,
        type: "inout",
        userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
        currency: "VND"
    )

    static let spend2 = TransactionEntity(
        id: "6bf2ee4b-e9ac-42d2-b0cc-0b57b3c3baee",
        timestamp: 1_709_372_124,
        sourceFundId: "131e5bf0-1fb9-46ce-8b5c-57e16758ba15",
        amount: 100_000,
        type: "inout",
        userId: "ff63d6b0-4a45-49c2-90c7-9fa17418f06c",
        currency: "VND"
    )
}
