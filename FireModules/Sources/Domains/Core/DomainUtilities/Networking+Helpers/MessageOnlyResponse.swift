import Foundation

public struct MessageOnlyResponse: Decodable, Equatable {
    public let message: String

    public enum CodingKeys: CodingKey {
        case message
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
    }
}
