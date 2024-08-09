import Dependencies

enum CategoryUseCaseKey: DependencyKey {
    public static let liveValue = CategoryUseCase.live()

    #if DEBUG
    static let testValue = CategoryUseCase.test()
    static let previewValue = CategoryUseCase.preview()
    #endif
}

public extension DependencyValues {
    var categoryUseCase: CategoryUseCase {
        get { self[CategoryUseCaseKey.self] }
        set { self[CategoryUseCaseKey.self] = newValue }
    }
}
