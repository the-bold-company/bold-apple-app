//
//  UserRepository.swift
//
//
//  Created by Hien Tran on 07/12/2023.
//

import Combine
import CombineExt
import CombineMoya

public struct UserAPIService {
    let client = MoyaClient<UserAPI>()

    public init() {}

    public func signUp(email: String, password: String) async throws -> LoginResponse {
        return try await client
            .requestPublisher(.signUp(email: email, password: password))
            .mapToResponse(LoginResponse.self)
            .async()
    }
}

// TODO: Move this to utilities
extension AnyPublisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var finishedWithoutValue = true // Keep track of case where the Publisher completes without emitting a value

            cancellable = first()
                .sink { result in
                    switch result {
                    case .finished:
                        if finishedWithoutValue {
                            continuation.resume(throwing: NetworkError.custom("Stream completes without emiiting a value"))
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    finishedWithoutValue = false
                    continuation.resume(with: .success(value))
                }
        }
    }
}
