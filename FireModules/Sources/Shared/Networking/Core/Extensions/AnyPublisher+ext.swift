//
//  AnyPublisher+ext.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import Combine
import Foundation
import Moya

public extension AnyPublisher where Output == Response, Failure == MoyaError {
    func mapToResponse<D: Decodable>(_: D.Type) -> AnyPublisher<D, NetworkError> {
        // swiftformat:disable:next redundantSelf
        return self
            .map(ApiResponse<D>.self)
            .tryMap { res -> D in
                switch res.asResult {
                case let .success(data):
                    return data
                case let .failure(error):
                    throw NetworkError.serverError(error)
                }
            }
            .mapError { err in
                if let moyaError = err as? MoyaError {
                    return NetworkError.moyaError(moyaError)
                } else if let networkError = err as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.unknown(err)
                }
            }
            .eraseToAnyPublisher()
    }
}
