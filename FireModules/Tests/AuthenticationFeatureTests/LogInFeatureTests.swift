// swiftlint:disable line_length
// swiftlint:disable file_length

import AuthAPIService
@testable import AuthenticationFeature
import ComposableArchitecture
import DomainEntities
import TestHelpers
import XCTest

@MainActor
final class LogInFeatureTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testEnterValidCredentials_ShouldLogInSuccessfully() async throws {
        // Arrange
        let mainQueue = DispatchQueue.test
        let store = TestStore(initialState: .init()) {
            LogInFeature()
        } withDependencies: {
            $0.context = .live
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
            $0.authAPIService = .directMock(logInResponseMock: """
            {
              "message": "Execute successfully",
              "data": {
                "accessToken": "eyJraWQiOiJQcVFzbE9vSmFZRV",
                "refreshToken": "eyJraWQiOiJQcVFzbE9vSmFZRV",
                "idToken": "eyJraWQiOiJQcVFzbE9vSmFZRV",
                "profile": {
                  "email": "hien2@yopmail.com"
                }
              }
            }
            """)
        }
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$emailText, "user@mouka.ai"))
        await store.send(.set(\.$passwordText, "Qwerty@123"))
        await mainQueue.advance(by: .milliseconds(500))
        await store.send(.view(.logInButtonTapped))

        // Assert
        await store.receive(\.delegate.userLoggedIn) {
            $0.logInProgress = .loaded(.success(.init(email: "hien2@yopmail.com")))
        }
    }

    func testShowError_WhenEnteringWrongCredentials() async throws {
        let mainQueue = DispatchQueue.test
        let store = TestStore(initialState: .init()) {
            LogInFeature()
        } withDependencies: {
            $0.context = .live
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
            $0.authAPIService = .directMock(logInResponseMock: """
            {
              "message": "Email or password is incorrect",
              "code": 14001
            }
            """)
        }
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$emailText, "user@mouka.ai"))
        await store.send(.set(\.$passwordText, "Qwerty@123"))
        await mainQueue.advance(by: .milliseconds(500))
        await store.send(.view(.logInButtonTapped))

        // Assert
        await store.receive(\.delegate.logInFailed.invalidCredentials) {
            $0.serverError = "Tên đăng nhập hoặc mật khẩu không đúng. Vui lòng thử lại hoặc đăng ký tài khoản mới!"
        }
    }

    func testLogInFailed_WhenResponseIsGenericError() async throws {
        let mainQueue = DispatchQueue.test
        let store = TestStore(initialState: .init()) {
            LogInFeature()
        } withDependencies: {
            $0.context = .live
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
            $0.authAPIService = .directMock(logInResponseMock: """
            {
              "message": "Something went wrong, please try again later",
              "code": 14003
            }
            """)
        }
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$emailText, "user@mouka.ai"))
        await store.send(.set(\.$passwordText, "Qwerty@123"))
        await mainQueue.advance(by: .milliseconds(500))
        await store.send(.view(.logInButtonTapped))

        // Assert
        await store.receive(\.delegate.logInFailed.genericError) {
            $0.serverError = "Oops! Đã xảy ra sự cố khi đăng nhập. Hãy thử lại sau một chút."
        }
    }

    func testFormInvalid_WhenPasswordIsEmpty() async throws {
        // Arrange
        let mainQueue = DispatchQueue.test
        let store = TestStore(initialState: .init()) {
            LogInFeature()
        } withDependencies: {
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$passwordText, ""))
        await mainQueue.advance(by: .milliseconds(500))

        // Assert
        await store.receive(\._local.verifyPassword) {
            XCTAssertTrue($0.formValidation.is(\.invalid))
            XCAssertNoDifference($0.formValidation[case: \.invalid]?.passwordValidationError, "Vui lòng điền thông tin.")
        }
    }

    func testFormInvalid_WhenEmailIsInvalid() async throws {
        // Arrange
        let mainQueue = DispatchQueue.test
        let store = TestStore(initialState: .init()) {
            LogInFeature()
        } withDependencies: {
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.set(\.$emailText, ""))
        await mainQueue.advance(by: .milliseconds(500))
        await store.receive(\._local.verifyEmail) {
            XCTAssertTrue($0.formValidation.is(\.invalid))
            XCAssertNoDifference($0.formValidation[case: \.invalid]?.emailValidationError, "Vui lòng điền thông tin.")
        }

        await store.send(.set(\.$emailText, "user"))
        await mainQueue.advance(by: .milliseconds(500))
        await store.receive(\._local.verifyEmail) {
            XCTAssertTrue($0.formValidation.is(\.invalid))
            XCAssertNoDifference($0.formValidation[case: \.invalid]?.emailValidationError, "Email không hợp lệ.")
        }

        await store.send(.set(\.$emailText, "user"))
        await mainQueue.advance(by: .milliseconds(500))
        await store.receive(\._local.verifyEmail) {
            XCTAssertTrue($0.formValidation.is(\.invalid))
            XCAssertNoDifference($0.formValidation[case: \.invalid]?.emailValidationError, "Email không hợp lệ.")
        }
    }
}

// swiftlint:enable line_length
// swiftlint:enable file_length
