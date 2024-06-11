import AuthAPIServiceInterface
import Dependencies

extension AuthAPIServiceKey: DependencyKey {
    public static let liveValue = AuthAPIService.live
}
