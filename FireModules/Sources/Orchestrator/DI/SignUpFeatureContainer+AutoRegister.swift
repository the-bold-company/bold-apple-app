extension SignUpFeatureContainer: AutoRegistering {
    public func autoRegister() {
        registerReducer.register {
            RegisterReducer(signUpUseCase: resolve(\.authenticationUseCase))
        }
    }
}
