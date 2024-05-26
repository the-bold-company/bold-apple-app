import DomainUtilities

struct NetworkErrorToDomainErrorMapper: DomainErrorMapper {
    func tranform(_ err: NetworkError) -> DomainError {
        switch err {
        case let .serverError(serverError):
            return DomainError(error: serverError, errorCode: serverError.code)
        default:
            return DomainError(error: err)
        }
    }
}
