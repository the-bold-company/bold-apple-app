import Factory

public final class SignUpFeatureContainer: SharedContainer {
    public static let shared = SignUpFeatureContainer()
    public let manager = ContainerManager()
}

public extension SignUpFeatureContainer {
    var registerReducer: Factory<RegisterReducer?> { self { nil } }
    var emailSignUpReducer: Factory<EmailSignUpReducer?> { self { nil } }
    var passwordSignUpReducer: Factory<PasswordSignUpReducer?> { self { nil } }
}
