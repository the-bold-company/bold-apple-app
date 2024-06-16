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

    var verifyEmailUseCase: VerifyEmailUseCase {
        get { self[VerifyEmailUseCaseKey.self] }
        set { self[VerifyEmailUseCaseKey.self] = newValue }
    }

    var logInUseCase: LogInUseCase {
        get { self[LogInUseCaseKey.self] }
        set { self[LogInUseCaseKey.self] = newValue }
    }

    var forgotPassword: ForgotPasswordUseCase {
        get { self[ForgotPasswordUseCaseKey.self] }
        set { self[ForgotPasswordUseCaseKey.self] = newValue }
    }
}

// MARK: SignUpUseCase dependency registration

enum SignUpUseCaseKey: DependencyKey {
    public static let liveValue = SignUpUseCase.live()
}

#if DEBUG
    extension SignUpUseCaseKey {
        static let testValue = SignUpUseCase(
            signUp: unimplemented("\(Self.self).signUp")
        )

        static let previewValue = SignUpUseCase.live()
    }
#endif

// MARK: LogInUseCase dependency registration

enum LogInUseCaseKey: DependencyKey {
    static let liveValue = LogInUseCase.live()

    #if DEBUG
        static let testValue = LogInUseCase(
            logInAsync: unimplemented("\(Self.self).logInAsync"),
            logIn: unimplemented("\(Self.self).logIn")
        )

        static let previewValue = LogInUseCase.live()
    #endif
}

// MARK: MFAUseCase dependency registration

enum MFAUseCaseKey: DependencyKey {
    public static let liveValue = MFAUseCase.live
}

#if DEBUG
    extension MFAUseCaseKey {
        static let testValue = MFAUseCase(
            verifyOTP: unimplemented("\(Self.self).verifyOTP"),
            confirmOTPResetPassword: unimplemented("\(Self.self).confirmOTPResetPassword")
        )
        static let previewValue = MFAUseCase.noop
    }
#endif

// MARK: VerifyEmail dependency registration

enum VerifyEmailUseCaseKey: DependencyKey {
    public static let liveValue = VerifyEmailUseCase.live

    #if DEBUG
        static let testValue = VerifyEmailUseCase(
            verifyExistence: unimplemented("\(Self.self).verifyExistence")
        )
        static let previewValue = VerifyEmailUseCase.live
    #endif
}

// MARK: ForgotPassword dependency registration

enum ForgotPasswordUseCaseKey: DependencyKey {
    public static let liveValue = ForgotPasswordUseCase.live()

    #if DEBUG
        static let testValue = ForgotPasswordUseCase(
            forgotPassword: unimplemented("\(Self.self).forgotPassword")
        )
        static let previewValue = ForgotPasswordUseCase.live()
    #endif
}
