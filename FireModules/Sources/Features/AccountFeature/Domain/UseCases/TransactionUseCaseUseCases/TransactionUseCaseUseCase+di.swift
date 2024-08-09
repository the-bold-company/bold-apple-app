import Dependencies

enum TransactionUseCaseKey: DependencyKey {
    public static let liveValue = TransactionUseCase.live()

    #if DEBUG
    static let testValue = TransactionUseCase.test()
    static let previewValue = TransactionUseCase.preview()
    #endif
}

public extension DependencyValues {
    var transactionUseCase: TransactionUseCase {
        get { self[TransactionUseCaseKey.self] }
        set { self[TransactionUseCaseKey.self] = newValue }
    }
}
