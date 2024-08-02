//
//  AnyPublisher+ext.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import Codextended
import Combine
import DomainUtilities
import Foundation
import Moya

public extension AnyPublisher where Output == Response, Failure == MoyaError {
    func mapToResponse<Model: Decodable>(_: Model.Type, apiVersion: APIVersion) -> AnyPublisher<Model, NetworkError> {
        switch apiVersion {
        case .v0:
            // swiftformat:disable:next redundantSelf
            return self
                .map(API.v0.Response<Model>.self)
                .tryMap { res -> Model in
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
        case .v1:
            // swiftformat:disable:next redundantSelf
            return self
                .map(API.v1.Response<Model>.self)
                .tryMap { res -> Model in
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
        case .v1_1:
            // swiftformat:disable:next redundantSelf
            return self
                .map(API.v1_1.Response<Model>.self)
                .tryMap { res -> Model in
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
}

public extension AnyPublisher where Failure == NetworkError {
    func mapErrorToDomainError() -> Publishers.MapError<Self, DomainError> {
        return mapError { NetworkErrorToDomainErrorMapper().tranform($0) }
    }
}

public extension Just where Output == Data {
    func mapToResponse<D: Decodable>(_: D.Type, apiVersion: APIVersion) -> AnyPublisher<D, NetworkError> {
        switch apiVersion {
        case .v0:
            // swiftformat:disable:next redundantSelf
            return self
                .tryMap { try $0.decoded() as API.v0.Response<D> }
                .tryMap { res -> D in
                    switch res.asResult {
                    case let .success(data):
                        return data
                    case let .failure(error):
                        throw NetworkError.serverError(error)
                    }
                }
                .mapError { err in
                    if let networkError = err as? NetworkError {
                        return networkError
                    } else {
                        return NetworkError.unknown(err)
                    }
                }
                .eraseToAnyPublisher()
        case .v1:
            // swiftformat:disable:next redundantSelf
            return self
                .tryMap { try $0.decoded() as API.v1.Response<D> }
                .tryMap { res -> D in
                    switch res.asResult {
                    case let .success(data):
                        return data
                    case let .failure(error):
                        throw NetworkError.serverError(error)
                    }
                }
                .mapError { err in
                    if let networkError = err as? NetworkError {
                        return networkError
                    } else {
                        return NetworkError.unknown(err)
                    }
                }
                .eraseToAnyPublisher()
        case .v1_1:
            // swiftformat:disable:next redundantSelf
            return self
                .tryMap { try $0.decoded() as API.v1_1.Response<D> }
                .tryMap { res -> D in
                    switch res.asResult {
                    case let .success(data):
                        return data
                    case let .failure(error):
                        throw NetworkError.serverError(error)
                    }
                }
                .mapError { err in
                    if let networkError = err as? NetworkError {
                        return networkError
                    } else {
                        return NetworkError.unknown(err)
                    }
                }
                .eraseToAnyPublisher()
        }
    }
}

// public extension AnyPublisher {
//
//    func transformError<R, OutputError>(_ mapper: R) -> Publishers.MapError<Self, OutputError> where R: ErrorMapper, OutputError == R.Output, Failure == R.Input {
//        return self
//            .mapError { AnyErrorMapper(mapper).transform($0) }
//    }
// }
//
// struct AnyErrorMapper<Input: Swift.Error, Output: Swift.Error> {
//    private let _transform: (Input) -> Output
//
//    init<M>(_ mapper: M) where M: ErrorMapper, Input == M.Input, Output == M.Output {
//        self._transform = mapper.tranform
//    }
//
//    func transform(_ input: Input) -> Output {
//        _transform(input)
//    }
// }
