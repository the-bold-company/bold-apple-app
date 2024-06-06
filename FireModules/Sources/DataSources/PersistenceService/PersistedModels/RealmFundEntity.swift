//
//  RealmFundEntity.swift
//
//
//  Created by Hien Tran on 16/02/2024.
//

import DomainEntities
import Foundation
import RealmSwift

class RealmFundEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted public var balance: Decimal128
    @Persisted public var name: String = ""
    @Persisted public var currency: String = ""
    @Persisted public var about: String?
    @Persisted public var fundType: String

    convenience init(fromFundEntity entity: FundEntity) {
        self.init()
        self.id = entity.id
        self.name = entity.name
        self.balance = Decimal128(value: entity.balance)
        self.currency = entity.currency
        self.about = entity.description
        self.fundType = entity.fundType.rawValue
    }
}

extension RealmFundEntity {
    func asFundEntity() -> FundEntity {
        return FundEntity(
            uuid: id,
            balance: balance.asSwiftDecimal,
            name: name,
            currency: currency,
            description: about,
            fundType: fundType
        )
    }
}

extension Decimal128 {
    var asSwiftDecimal: Decimal {
        if let decimalValue = Decimal(string: stringValue) {
            return decimalValue
        } else {
            fatalError("Failed not convert Decimal128 (value: \(stringValue) to Decimal")
        }
    }
}
