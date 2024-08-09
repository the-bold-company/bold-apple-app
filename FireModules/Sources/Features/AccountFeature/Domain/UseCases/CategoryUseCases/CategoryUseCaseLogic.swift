import CasePaths
import ComposableArchitecture
import DomainEntities
import Foundation

public enum CategoryUseCaseLogic {}

// MARK: - Create category use case logic

// MARK: - Get categories use case logic

public typealias GetCategoriesInput = CategoryUseCaseLogic.GetCategories.Input
public typealias GetCategoriesResponse = CategoryUseCaseLogic.GetCategories.Response
public typealias GetCategoriesFailure = CategoryUseCaseLogic.GetCategories.Failure
public typealias GetCategoriesOutput = Result<GetCategoriesResponse, GetCategoriesFailure>
public extension CategoryUseCaseLogic {
    enum GetCategories: UseCaseRequirements {
        @CasePathable
        public enum Input: String, Equatable {
            case moneyIn = "money-in"
            case moneyOut = "money-out"
        }

        @CasePathable
        public enum Response {
            case moneyIn(IdentifiedArrayOf<MoneyInCategory>)
            case moneyOut(IdentifiedArrayOf<MoneyOutCategory>)
        }

        @CasePathable
        public enum Failure: LocalizedError, Equatable {
            case genericError(DomainError)
            case invalidInputs(Input)

            public init(domainError: DomainError) {
                switch domainError.errorCode {
                default:
                    self = .genericError(domainError)
                }
            }

            public var errorDescription: String? {
                switch self {
                case let .genericError(error):
                    return error.errorDescription
                case let .invalidInputs(input):
                    return "Input invalid: \(input)"
                }
            }

            public var failureReason: String? {
                switch self {
                case let .genericError(error):
                    return error.failureReason
                case .invalidInputs:
                    return "Invalid inputs"
                }
            }
        }
    }
}
