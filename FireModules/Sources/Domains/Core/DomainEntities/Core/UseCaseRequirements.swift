import Foundation

public protocol UseCaseRequirements {
    associatedtype Input
    associatedtype Response
    associatedtype Failure: LocalizedError, Equatable
}
