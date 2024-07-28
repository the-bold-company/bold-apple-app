import Dependencies

public extension DependencyValues {
    var AccountUseCase: AccountUseCase {
        get { self[AccountUseCaseKey.self] }
        set { self[AccountUseCaseKey.self] = newValue }
    }
}

enum AccountUseCaseKey: DependencyKey {
    public static let liveValue = AccountUseCase.live()

    #if DEBUG
    static let testValue = AccountUseCase.test()
    static let previewValue = AccountUseCase.preview()
    #endif
}
