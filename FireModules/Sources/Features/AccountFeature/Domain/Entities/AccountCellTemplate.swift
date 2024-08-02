import CasePaths
import Foundation

@CasePathable
public enum AccountCellValue: Codable, Equatable {
    case boolean(Bool)
    case number(Decimal)
    case string(String)
}

public extension AccountCellValue {
    init(from decoder: any Decoder) throws {
        let valueType: String = try decoder.decode("valueType")

        switch valueType {
        case "BooleanType":
            let boolValue: Bool = try decoder.decode("value")
            self = .boolean(boolValue)
        case "NumberType":
            let numberValue: Decimal = try decoder.decode("value")
            self = .number(numberValue)
        case "StringType":
            let stringValue: String = try decoder.decode("value")
            self = .string(stringValue)
        default:
            throw NSError(
                domain: "AccountCellValueError",
                code: -999_999,
                userInfo: [
                    NSLocalizedDescriptionKey: "Value type \(valueType) is not supported",
                ]
            )
        }
    }

    func encode(to encoder: any Encoder) throws {
        switch self {
        case let .boolean(bool):
            try encoder.encode("BooleanType", for: "valueType")
            try encoder.encode(bool, for: "value")
        case let .number(decimal):
            try encoder.encode("NumberType", for: "valueType")
            try encoder.encode(decimal, for: "value")
        case let .string(string):
            try encoder.encode("StringType", for: "valueType")
            try encoder.encode(string, for: "value")
        }
    }
}
