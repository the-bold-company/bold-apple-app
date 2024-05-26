import Foundation

public protocol ErrorMapper<Input, Output> {
    associatedtype Input: Error
    associatedtype Output: Error

    func tranform(_ err: Input) -> Output
}

public protocol DomainErrorMapper: ErrorMapper where Output == DomainError {}
