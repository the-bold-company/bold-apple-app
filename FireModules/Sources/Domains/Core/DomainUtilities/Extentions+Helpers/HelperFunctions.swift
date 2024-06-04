

public func autoCatch<Success>(_ perform: () async throws -> Success) async -> DomainResult<Success> {
    do {
        let result = try await perform()
        return .success(result)
    } catch {
        return .failure(error.eraseToDomainError())
    }
}
