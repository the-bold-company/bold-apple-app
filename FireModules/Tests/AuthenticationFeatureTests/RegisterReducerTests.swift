//// swiftlint:disable line_length
//// swiftlint:disable file_length
//
// import AccountRegisterUseCase
// import ComposableArchitecture
// @testable import SignUpFeature
// import TestHelpers
// import XCTest
//
// @MainActor
// final class RegisterReducerTests: XCTestCase {
//    private var accountRegisterUseCase: AccountRegisterUseCaseProtocolMock!
//    private var initialState: RegisterReducer.State!
//    override func setUpWithError() throws {
//        initialState = .init()
//        accountRegisterUseCase = AccountRegisterUseCaseProtocolMock()
//    }
//
//    func testEmailIsInvalid_WhenLengthConditionIsNotMet() async throws {
//        // Arrange
//        let store = TestStore(initialState: initialState) {
//            RegisterReducer(accountRegisterUseCase: accountRegisterUseCase)
//        }
//        store.exhaustivity = .off
//
//        // Act & Assert
//        await store.send(.set(\.$email, "xyz@")) {
//            $0.emailValidationError = "Email invalid"
//        }
//    }
//
//    func testEmailIsValid_WhenAllConditionsAreMet() async throws {
//        // Arrange
//        let store = TestStore(initialState: initialState) {
//            RegisterReducer(accountRegisterUseCase: accountRegisterUseCase)
//        }
//        store.exhaustivity = .off
//
//        // Act & Assert
//        await store.send(.set(\.$email, "iam.groot@fire.com")) {
//            $0.emailValidationError = nil
//        }
//    }
//
//    func testPasswordIsInvalid_WhenLengthConditionIsNotMet() async throws {
//        // Arrange
//        let store = TestStore(initialState: initialState) {
//            RegisterReducer(accountRegisterUseCase: accountRegisterUseCase)
//        }
//        store.exhaustivity = .off
//
//        // Act & Assert
//        await store.send(.set(\.$password, "Qwerty")) {
//            $0.passwordValidationError = "Password length must be greater than 6"
//        }
//    }
//
//    func testPasswordIsValid_WhenAllConditionsAreMet() async throws {
//        // Arrange
//        let store = TestStore(initialState: initialState) {
//            RegisterReducer(accountRegisterUseCase: accountRegisterUseCase)
//        }
//        store.exhaustivity = .off
//
//        // Act & Assert
//        await store.send(.set(\.$password, "Qwerty@123")) {
//            $0.passwordValidationError = nil
//        }
//    }
//
//    func testRegisterSuccessfully() async throws {
//        // Arrange
//        accountRegisterUseCase.registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue = .success(AuthenticatedUserEntity.user1)
//        let store = TestStore(initialState: initialState) {
//            RegisterReducer(accountRegisterUseCase: accountRegisterUseCase)
//        }
//        store.exhaustivity = .off
//
//        // Act
//        await store.send(.set(\.$email, "user@fire.com"))
//        await store.send(.set(\.$password, "Qwerty@123"))
//        await store.send(.createUserButtonTapped)
//
//        // Assert
//        await store.receive(\.createUserSuccesfully) {
//            $0.accountCreationState = .loaded(AuthenticatedUserEntity.user1)
//        }
//    }
//
//    func testRegisterFailed() async throws {
//        // Arrange
//        accountRegisterUseCase.registerAccountEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure = { email, password in
//            return .failure(DomainError.custom(description: "Failed to register user with email '\(email)' and password '\(password)'"))
//        }
//        let store = TestStore(initialState: initialState) {
//            RegisterReducer(accountRegisterUseCase: accountRegisterUseCase)
//        }
//        store.exhaustivity = .off
//
//        // Act
//        await store.send(.set(\.$email, "user@fire.com"))
//        await store.send(.set(\.$password, "Qwerty@123"))
//        await store.send(.createUserButtonTapped)
//
//        // Assert
//        await store.receive(\.createUserFailure) {
//            $0.accountCreationState = .failure(DomainError.custom(description: "Failed to register user with email 'user@fire.com' and password 'Qwerty@123'"))
//        }
//    }
// }
//
//// swiftlint:enable line_length
//// swiftlint:enable file_length
