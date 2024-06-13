import Dependencies

public extension DependencyValues {
    var signUpUseCase: SignUpUseCase {
        get { self[SignUpUseCaseKey.self] }
        set { self[SignUpUseCaseKey.self] = newValue }
    }

    var mfaUseCase: MFAUseCase {
        get { self[MFAUseCaseKey.self] }
        set { self[MFAUseCaseKey.self] = newValue }
    }
}

// MARK: SignUpUseCase dependency registration

enum SignUpUseCaseKey: DependencyKey {
    public static let liveValue = SignUpUseCase.live
}

#if DEBUG
    extension SignUpUseCaseKey {
        static let testValue = SignUpUseCase(
            signUp: unimplemented("\(Self.self).signUp")
        )

        static let previewValue = SignUpUseCase.noop
    }
#endif

// MARK: LogInUseCase dependency registration

// MARK: MFAUseCase dependency registration

enum MFAUseCaseKey: DependencyKey {
    public static let liveValue = MFAUseCase.live
}

#if DEBUG
    extension MFAUseCaseKey {
        static let testValue = MFAUseCase(
            verifyOTP: unimplemented("\(Self.self).verifyOTP")
        )
        static let previewValue = MFAUseCase.noop
    }
#endif
