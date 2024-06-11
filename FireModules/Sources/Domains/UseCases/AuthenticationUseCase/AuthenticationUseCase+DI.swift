import Dependencies

// MARK: SignUpUseCase dependency registration

public enum SignUpUseCaseKey: DependencyKey {
    public static let liveValue = SignUpUseCase.live
}

#if DEBUG
    public extension SignUpUseCaseKey {
        static let testValue = SignUpUseCase(
            signUp: unimplemented("\(Self.self).signUp")
        )

        static let previewValue = SignUpUseCase.noop
    }
#endif

public extension DependencyValues {
    var signUpUseCase: SignUpUseCase {
        get { self[SignUpUseCaseKey.self] }
        set { self[SignUpUseCaseKey.self] = newValue }
    }
}

// MARK: LogInUseCase dependency registration
