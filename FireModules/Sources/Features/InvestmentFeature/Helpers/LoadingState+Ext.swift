import DomainEntities

extension LoadingState where Success == [InvestmentPortfolioEntity] {
    /// Return `true` only when the loaded result is an empty array
    var hasEmptyResult: Bool {
        guard let result else { return false }

        return result.isEmpty
    }

    /// Return `true` when the state is `.loading` or `.loaded`. Use this to apply skeleton loading
    var isLoadingOrLoaded: Bool {
        return isLoading || hasResult
    }
}
