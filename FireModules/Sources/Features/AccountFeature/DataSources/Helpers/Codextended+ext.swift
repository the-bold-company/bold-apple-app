import Codextended

// TODO: Move this to Shared
public extension Encoder {
    func encodeIfPresent(_ value: (some Encodable)?, for key: String) throws {
        try encodeIfPresent(value, for: _AnyCodingKey(key))
    }

    func encodeIfPresent<K: CodingKey>(_ value: (some Encodable)?, for key: K) throws {
        var container = container(keyedBy: K.self)
        try container.encodeIfPresent(value, forKey: key)
    }
}

private struct _AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(_ string: String) {
        self.stringValue = string
    }

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}
