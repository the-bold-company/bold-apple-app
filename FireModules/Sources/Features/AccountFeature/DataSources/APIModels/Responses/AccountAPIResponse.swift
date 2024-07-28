import Codextended
import Foundation

public struct AccountAPIResponse: Decodable {
    let id: String
    let name: String
    let type: String
    let status: String
    let icon: String?
    let currencyId: String
    let userId: String
    let cells: [Cell]

    struct Cell: Decodable {
        let id: String
        let name: String
        let value: String
        let valueType: String
        let accountId: String
        let index: Int
        let title: String?
        let createdBy: String
    }
}
