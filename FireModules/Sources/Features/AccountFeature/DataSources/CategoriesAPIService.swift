import ComposableArchitecture
import DomainUtilities
import Foundation
import Utilities

public typealias GetCategoriesResult = Result<[CategoryAPIResponse], DomainError>
public typealias CreateCategoryResult = Result<CategoryAPIResponse, DomainError>

public struct CategoriesAPIService {
    public var getCategories: @Sendable (_ transferType: String) -> Effect<GetCategoriesResult>
    public var createCategory: @Sendable (_ icon: String, _ name: String, _ transferType: String) -> Effect<CreateCategoryResult>
}

public enum CategoriesAPIServiceKey: DependencyKey {
    public static let liveValue = CategoriesAPIService.live

    public static let previewValue = CategoriesAPIService.local(
        getCategoriesMockURL: .local(backward: 6).appendingPathComponent("mock/account-management/v1/categories/getCategories/response.json"),
        createCategoryMockURL: .local(backward: 6).appendingPathComponent("mock/account-management/v1/categories/create/response.json")
    )

    public static let testValue = CategoriesAPIService(
        getCategories: unimplemented("\(Self.self).getCategories"),
        createCategory: unimplemented("\(Self.self).createCategory")
    )
}

public extension DependencyValues {
    var categoriesAPIService: CategoriesAPIService {
        get { self[CategoriesAPIServiceKey.self] }
        set { self[CategoriesAPIServiceKey.self] = newValue }
    }
}
