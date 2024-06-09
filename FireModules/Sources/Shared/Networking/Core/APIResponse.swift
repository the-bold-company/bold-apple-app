//
//  File.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//
import Codextended
import DomainUtilities
import Foundation

public struct ApiResponse {
    private init() {}
}

public protocol ServerError: Decodable, LocalizedError {
    var message: String { get }
    var code: Int { get }
}

public extension ServerError {
    /// Localized message for debuggin purposes. Don't show this to user
    var errorDescription: String? {
        return "Error code: \(code): \(message)"
    }

    /// A localized message describing the reason for the failure. Use this to customize error message that is shown to user
    var failureReason: String? {
        return message
    }
}

public enum APIVersion {
    case v0
    case v1
}

public enum API {
    public enum v0 {
        public struct Response<M: Decodable>: Decodable {
            public let code: Int
            public let response: M?
            public let error: Failure?

            public var asResult: Result<M, Failure> {
                if let response, code == 1, error == nil {
                    return Result<M, Failure>.success(response)
                } else if let error, code != 1, response == nil {
                    return Result<M, Failure>.failure(error)
                }

                fatalError("If it gets here, something is wrong")
            }

            public init(from decoder: Decoder) throws {
                self.code = try decoder.decode("code")
                self.response = try decoder.decodeIfPresent("response")
                self.error = try? Failure(from: decoder)
            }
        }

        public struct Failure: ServerError {
            public let code: Int
            public let message: String

            private enum CodingKeys: String, CodingKey {
                case code
                case error
            }

            private enum ErrorKeys: String, CodingKey {
                case reason
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.code = try container.decode(Int.self, forKey: .code)

                let errorContainer = try container.nestedContainer(keyedBy: ErrorKeys.self, forKey: .error)
                self.message = try errorContainer.decode(String.self, forKey: .reason)
            }

            /// Localized message for debuggin purposes. Don't show this to user
            public var errorDescription: String? {
                return "Error code: \(code): \(message)"
            }

            /// A localized message describing the reason for the failure. Use this to customize error message that is shown to user
            public var failureReason: String? {
                return message
            }
        }
    }

    public enum v1 {
        public struct Response<M: Decodable>: Decodable {
            public let statusCode: Int
            public let data: M?
            public let message: String
            public let error: Failure?

            public var asResult: Result<M, Failure> {
                if let data, error == nil {
                    return Result<M, Failure>.success(data)
                } else if let error {
                    return Result<M, Failure>.failure(error)
                }

                fatalError("If it gets here, something is wrong")
            }

            public init(from decoder: any Decoder) throws {
                self.statusCode = try decoder.decode("statusCode")
                self.data = try decoder.decodeIfPresent("data")
                self.message = try decoder.decode("message")
                self.error = try? Failure(from: decoder)
            }
        }

        public struct Failure: ServerError {
            public let code: Int
            public let message: String

            public init(from decoder: Decoder) throws {
                self.code = try decoder.decode("code")
                self.message = try decoder.decode("message")
            }
        }
    }
}
