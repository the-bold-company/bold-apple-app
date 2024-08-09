import ComposableArchitecture

public struct CategoryUseCase: Sendable {
    public var getCategories: @Sendable (_ input: GetCategoriesInput) -> Effect<GetCategoriesOutput>
}
