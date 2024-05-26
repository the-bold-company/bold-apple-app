//
//  File.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//
import Codextended
import Foundation

public struct ApiResponse<M: Decodable>: Decodable {
    public let code: Int
    public let response: M?
    public let error: ServerError?

    var asResult: Result<M, ServerError> {
        if let response, code == 1, error == nil {
            return Result<M, ServerError>.success(response)
        } else if let error, code != 1, response == nil {
            return Result<M, ServerError>.failure(error)
        }

        fatalError("If it gets here, something is wrong")
    }

    public init(from decoder: Decoder) throws {
        self.code = try decoder.decode("code")
        self.response = try decoder.decodeIfPresent("response")
        self.error = try? ServerError(from: decoder)
    }
}
