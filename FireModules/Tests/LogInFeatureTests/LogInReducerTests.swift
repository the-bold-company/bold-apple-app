////
////  LogInReducerTests.swift
////
////
////  Created by Hien Tran on 20/02/2024.
////
//
// import ComposableArchitecture
// import DevSettingsUseCase
////import DI
// import DomainEntities
// @testable import LogInFeature
// import TestHelpers
// import XCTest
//
// @MainActor
// final class LogInReducerTests: XCTestCase {
//    var initialState: LoginReducer.State!
//
//    override func setUpWithError() throws {
//        Container.shared.manager.trace.toggle()
//        Container.shared.manager.push()
//
//        initialState = LoginReducer.State()
//        initialState.email = "user@fire.com"
//        initialState.password = "P@ssword123"
//    }
//
//    override func tearDownWithError() throws {
//        Container.shared.manager.pop()
//    }
//
//    func testUsernameAndPassword_isPreFilled_whenDevSettingsAreSet() async throws {
//        // Arrange
//        var mockCredentials = DevSettings.Credentials()
//        mockCredentials.username = "user@fire.com"
//        mockCredentials.password = "P@ssword123"
//        Container.shared.devSettingsUseCase.register {
//            DevSettingsUseCase.mock(
//                initialDevSettings: DevSettings(credentials: mockCredentials)
//            )
//        }
//
//        let store = TestStore(
//            initialState: LoginReducer.State(),
//            reducer: { LoginReducer(logInUseCase: LogInUseCaseProtocolMock()) }
//        )
//
//        // Assert
//        XCAssertNoDifference(store.state.email, "user@fire.com")
//        XCAssertNoDifference(store.state.password, "P@ssword123")
//    }
//
//    func testUsernameAndPassword_isEmpty_whenDevSettingsAreNotSet() async throws {
//        // Arrange
//        Container.shared.devSettingsUseCase.register {
//            DevSettingsUseCase.mock(initialDevSettings: DevSettings())
//        }
//        let store = TestStore(
//            initialState: LoginReducer.State(),
//            reducer: { LoginReducer(logInUseCase: LogInUseCaseProtocolMock()) }
//        )
//
//        // Act & Assert
//        XCAssertTCAStateNoDifference(store.state, LoginReducer.State())
//    }
//
//    func testNavigateToHome_WhenLogInSuccessfully() async throws {
//        // Arrange
//        let mockUser = AuthenticatedUserEntity(email: "user@fire.com")
//        let logInUseCaseMock = LogInUseCaseProtocolMock()
//        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue = .success(mockUser)
//        let store = TestStore(
//            initialState: initialState,
//            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
//        )
//        store.exhaustivity = .off(showSkippedAssertions: false)
//
//        // Act
//        await store.send(.delegate(.logInButtonTapped))
//
//        // Assert
//        await store.receive(\.logInSuccesfully)
//        await store.receive(/LoginReducer.Action.navigate(.goToHome))
//    }
//
//    func testShowError_WhenLogInFailed() async throws {
//        // Arrange
//        let mockUser = AuthenticatedUserEntity(email: "user@fire.com")
//        let logInUseCaseMock = LogInUseCaseProtocolMock()
//        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure = { _, _ in
//            return .failure(DomainError.custom(description: "Something's wrong"))
//        }
//        let store = TestStore(
//            initialState: initialState,
//            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
//        )
//        store.exhaustivity = .off(showSkippedAssertions: false)
//
//        // Act
//        await store.send(.delegate(.logInButtonTapped))
//
//        // Assert
//        await store.receive(\.logInFailure) {
//            $0.loginError = "An error has occured"
//        }
//    }
//
//    func testLoadingState_WhenLogInSuccessfully() async throws {
//        // Arrange
//        let logInUseCaseMock = LogInUseCaseProtocolMock()
//        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue = .success(AuthenticatedUserEntity(email: "user@fire.com"))
//        let store = TestStore(
//            initialState: initialState,
//            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
//        )
//        store.exhaustivity = .off(showSkippedAssertions: false)
//
//        // Act & Assert
//        await store.send(.delegate(.logInButtonTapped)) {
//            $0.logInInProgress = true
//        }
//
//        await store.receive(\.logInSuccesfully) {
//            $0.logInInProgress = false
//        }
//    }
//
//    func testLoadingState_WhenLogInFailed() async throws {
//        // Arrange
//        let logInUseCaseMock = LogInUseCaseProtocolMock()
//        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure = { _, _ in
//            return .failure(DomainError.custom(description: "Something's wrong"))
//        }
//        let store = TestStore(
//            initialState: initialState,
//            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
//        )
//        store.exhaustivity = .off(showSkippedAssertions: false)
//
//        // Act & Assert
//        await store.send(.delegate(.logInButtonTapped)) {
//            $0.logInInProgress = true
//        }
//
//        await store.receive(\.logInFailure) {
//            $0.logInInProgress = false
//        }
//    }
//
//    func testUnableToLogIn_WhenInputsAreInvalid() async throws {
//        let mockUser = AuthenticatedUserEntity(email: "user@fire.com")
//        let logInUseCaseMock = LogInUseCaseProtocolMock()
//        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue = .success(mockUser)
//        let store = TestStore(
//            initialState: LoginReducer.State(),
//            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
//        )
//
//        // Act & Assert
//        await store.send(.delegate(.logInButtonTapped))
//        XCAssertTCAStateNoDifference(store.state.areInputsValid, false)
//    }
// }
