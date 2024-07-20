import Codextended

public struct VerifyEmailResponse: Decodable {
    public let isExisted: Bool
    public let isExternalEmail: Bool

    public init(from decoder: any Decoder) throws {
        self.isExisted = try decoder.decode("isExisted")
        self.isExternalEmail = try decoder.decode("isExternalEmail")
    }
}
