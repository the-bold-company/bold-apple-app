extension SignUpFeatureContainer: AutoRegistering {
    public func autoRegister() {
        registerReducer.register {
            RegisterReducer()
        }

        emailSignUpReducer.register {
            EmailSignUpReducer()
        }

        passwordSignUpReducer.register {
            PasswordSignUpReducer()
        }
    }
}
