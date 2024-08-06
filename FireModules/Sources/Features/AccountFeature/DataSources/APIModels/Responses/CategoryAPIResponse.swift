import Codextended
import DomainEntities
import Foundation

public struct CategoryAPIResponse: Decodable {
    let id: String
    let type: String
    let icon: String
    let name: String

    public init(from decoder: any Decoder) throws {
        self.id = try decoder.decode("id")
        self.type = try decoder.decode("type")
        self.icon = try decoder.decode("icon")
        self.name = try decoder.decode("name")
    }
}
