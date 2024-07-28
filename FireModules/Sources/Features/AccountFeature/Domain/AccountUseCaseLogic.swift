import CasePaths
import ComposableArchitecture
import DomainEntities
import Foundation

public enum AccountUseCaseLogic {}

// MARK: - Create account use case logic

public typealias CreateAccountInput = AccountUseCaseLogic.CreateAccount.Input
public typealias CreateAccountResponse = AccountUseCaseLogic.CreateAccount.Response
public typealias CreateAccountFailure = AccountUseCaseLogic.CreateAccount.Failure
public typealias CreateAccountOutput = Result<CreateAccountResponse, CreateAccountFailure>
public extension AccountUseCaseLogic {
    enum CreateAccount: UseCaseRequirements {
        @CasePathable
        public enum Input: Equatable {
            case bankAccount(
                accountName: DefaultLengthConstrainedString,
                icon: String,
                balance: FiatAccountBalance,
                currency: Currency
            )
            case creditCard(
                accountName: DefaultLengthConstrainedString,
                icon: String,
                balance: FiatAccountBalance,
                currency: Currency
            )

            var identity: String {
                switch self {
                case .bankAccount: return "bank-account"
                case .creditCard: return "credit-account"
                }
            }
        }

        public struct Response: Equatable {
            public init() {}
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
