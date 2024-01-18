//
//  AnyPublisher+async.swift
//
//
//  Created by Hien Tran on 06/01/2024.
//

import Combine
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
