import Dependencies
import DomainEntities
import Foundation

public struct KeychainService {
    public var setCredentials: @Sendable (_ accessToken: String, _ refreshToken: String, _ idToken: String) -> Result<CredentialsEntity, KeychainError>
    public var getAccessToken: @Sendable () -> Result<String, KeychainError>
    public var getRefreshToken: @Sendable () -> Result<String, KeychainError>
    public var getIDToken: @Sendable () -> Result<String, KeychainError>
    public var removeCredentials: @Sendable () -> Result<Void, KeychainError>
    public var getCredentials: @Sendable () throws -> Result<CredentialsEntity, KeychainError>

    public init(
        setCredentials: @Sendable @escaping (_ accessToken: String, _ refreshToken: String, _ idToken: String) -> Result<CredentialsEntity, KeychainError>,
        getAccessToken: @Sendable @escaping () -> Result<String, KeychainError>,
        getRefreshToken: @Sendable @escaping () -> Result<String, KeychainError>,
        getIDToken: @Sendable @escaping () -> Result<String, KeychainError>,
        removeCredentials: @Sendable @escaping () -> Result<Void, KeychainError>,
        getCredentials: @Sendable @escaping () -> Result<CredentialsEntity, KeychainError>
    ) {
        self.setCredentials = setCredentials
        self.getAccessToken = getAccessToken
        self.getRefreshToken = getRefreshToken
        self.getIDToken = getIDToken
        self.removeCredentials = removeCredentials
        self.getCredentials = getCredentials
    }
}

public extension KeychainService {
    static var nope: Self {
        .init(
            setCredentials: { _, _, _ in .success(CredentialsEntity(accessToken: "", refreshToken: "", idToken: "")) },
            getAccessToken: { .success("") },
            getRefreshToken: { .success("") },
            getIDToken: { .success("") },
            removeCredentials: { .success(()) },
            getCredentials: { .success(CredentialsEntity(accessToken: "", refreshToken: "", idToken: "")) }
        )
    }
}

public enum KeychainServiceKey: TestDependencyKey {
    public static let testValue = KeychainService.nope
    public static let previewValue = KeychainService.nope
}

public extension DependencyValues {
    var keychainService: KeychainService {
        get { self[KeychainServiceKey.self] }
        set { self[KeychainServiceKey.self] = newValue }
    }
}
