import CasePaths
import ComposableArchitecture
import DomainEntities
import Foundation

public enum TransactionUseCaseUseCaseLogic {}

// MARK: - Create transaction

public typealias CreateTransactionInput = TransactionUseCaseUseCaseLogic.CreateTransaction.Input
public typealias CreateTransactionResponse = TransactionUseCaseUseCaseLogic.CreateTransaction.Response
public typealias CreateTransactionFailure = TransactionUseCaseUseCaseLogic.CreateTransaction.Failure
public typealias CreateTransactionOutput = Result<CreateTransactionResponse, CreateTransactionFailure>
public extension TransactionUseCaseUseCaseLogic {
    enum CreateTransaction: UseCaseRequirements {
        @CasePathable
        public enum Input: Equatable {
            case moneyIn(amount: Money, accountId: Id, timestamp: Timestamp, categoryId: Id?, name: DefaultLengthConstrainedString?, note: DefaultLengthConstrainedString?)
            case moneyOut
            case internalTransfer
        }

        @CasePathable
        public enum Response {
            case moneyIn(Transaction)
            case moneyOut(Transaction)
            case internalTransfer(Transaction)
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
