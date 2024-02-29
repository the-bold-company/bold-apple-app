//
//  LogInReducerTests.swift
//
//
//  Created by Hien Tran on 20/02/2024.
//

import XCTest

import ComposableArchitecture
import DevSettingsUseCase
import DomainEntities
@testable import LogInFeature
import LogInUseCase
import TestHelpers

@MainActor
final class LogInReducerTests: XCTestCase {
    var initialState: LoginReducer.State!

    override func setUpWithError() throws {
        initialState = LoginReducer.State()
        initialState.email = "user@fire.com"
        initialState.password = "P@ssword123"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUsernameAndPassword_isPreFilled_whenDevSettingsAreSet() async throws {
        // Arrange
        let store = TestStore(
            initialState: LoginReducer.State(),
            reducer: { LoginReducer(logInUseCase: LogInUseCaseProtocolMock()) },
            withDependencies: { dependency in
                var mockCredentials = DevSettings.Credentials()
                mockCredentials.username = "user@fire.com"
                mockCredentials.password = "P@ssword123"
                dependency.devSettings = DevSettingsClient.mock(
                    initialDevSettings: DevSettings(
                        credentials: mockCredentials
                    )
                )
            }
        )

        // Act
        var expectedState = LoginReducer.State()
        expectedState.email = "user@fire.com"
        expectedState.password = "P@ssword123"

        // Assert
        XCAssertTCAStateNoDifference(store.state, expectedState)
    }

    func testUsernameAndPassword_isEmpty_whenDevSettingsAreNotSet() async throws {
        // Arrange
        let store = TestStore(
            initialState: LoginReducer.State(),
            reducer: { LoginReducer(logInUseCase: LogInUseCaseProtocolMock()) }
        )

        // Act & Assert
        XCAssertTCAStateNoDifference(store.state, LoginReducer.State())
    }

    func testNavigateToHome_WhenLogInSuccessfully() async throws {
        // Arrange
        let mockUser = AuthenticatedUserEntity(email: "user@fire.com")
        let logInUseCaseMock = LogInUseCaseProtocolMock()
        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue = .success(mockUser)
        let store = TestStore(
            initialState: initialState,
            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.delegate(.logInButtonTapped))

        // Assert
        await store.receive(\.logInSuccesfully)
        await store.receive(/LoginReducer.Action.navigate(.goToHome))
    }

    func testShowError_WhenLogInFailed() async throws {
        // Arrange
        let mockUser = AuthenticatedUserEntity(email: "user@fire.com")
        let logInUseCaseMock = LogInUseCaseProtocolMock()
        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure = { _, _ in
            return .failure(DomainError.custom(description: "Something's wrong"))
        }
        let store = TestStore(
            initialState: initialState,
            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act
        await store.send(.delegate(.logInButtonTapped))

        // Assert
        await store.receive(\.logInFailure) {
            $0.loginError = "Something's wrong"
        }
    }

    func testLoadingState_WhenLogInSuccessfully() async throws {
        // Arrange
        let logInUseCaseMock = LogInUseCaseProtocolMock()
        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue = .success(AuthenticatedUserEntity(email: "user@fire.com"))
        let store = TestStore(
            initialState: initialState,
            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act & Assert
        await store.send(.delegate(.logInButtonTapped)) {
            $0.logInInProgress = true
        }

        await store.receive(\.logInSuccesfully) {
            $0.logInInProgress = false
        }
    }

    func testLoadingState_WhenLogInFailed() async throws {
        // Arrange
        let logInUseCaseMock = LogInUseCaseProtocolMock()
        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorClosure = { _, _ in
            return .failure(DomainError.custom(description: "Something's wrong"))
        }
        let store = TestStore(
            initialState: initialState,
            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
        )
        store.exhaustivity = .off(showSkippedAssertions: false)

        // Act & Assert
        await store.send(.delegate(.logInButtonTapped)) {
            $0.logInInProgress = true
        }

        await store.receive(\.logInFailure) {
            $0.logInInProgress = false
        }
    }

    func testUnableToLogIn_WhenInputsAreInvalid() async throws {
        let mockUser = AuthenticatedUserEntity(email: "user@fire.com")
        let logInUseCaseMock = LogInUseCaseProtocolMock()
        logInUseCaseMock.loginEmailStringPasswordStringResultAuthenticatedUserEntityDomainErrorReturnValue = .success(mockUser)
        let store = TestStore(
            initialState: LoginReducer.State(),
            reducer: { LoginReducer(logInUseCase: logInUseCaseMock) }
        )

        // Act & Assert
        await store.send(.delegate(.logInButtonTapped))
        XCAssertTCAStateNoDifference(store.state.areInputsValid, false)
    }
}
