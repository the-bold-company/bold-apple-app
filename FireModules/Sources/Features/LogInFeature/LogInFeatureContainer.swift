import AuthenticationUseCase
import DevSettingsUseCase
import Factory

public final class LogInFeatureContainer: SharedContainer {
    public static let shared = LogInFeatureContainer()
    public let manager = ContainerManager()
}

public extension LogInFeatureContainer {
    var devSettingsUseCase: Factory<DevSettingsUseCase?> { self { nil } }
    var logInReducer: Factory<LoginReducer?> { self { nil } }
}
