// swiftlint:disable force_unwrapping

extension LogInFeatureContainer: AutoRegistering {
    public func autoRegister() {
        devSettingsUseCase.register { resolve(\.devSettingsUseCase) }
        logInReducer.register {
            LoginReducer(logInUseCase: resolve(\.logInUseCase))
        }
    }
}

// swiftlint:enable force_unwrapping
