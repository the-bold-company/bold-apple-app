
import AuthAPIService
@testable import AuthenticationFeature
import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import TestHelpers
import XCTest

@MainActor
final class ForgotPasswordFeatureTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testMustReturnError_WhenEmailAlreadyExists() async throws {
        // Arrange
        let store = TestStore(initialState: .init()) {
            ForgotPasswordFeature()
        } withDependencies: {
            $0.authAPIService = .directMock(forgotPasswordMock: """
            {
              "message": "Username/client id combination not found.",
              "code": 13002
            }
            """)
        }
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$emailText, "user@mouka.ai"))
        await store.send(.view(.nextButtonTapped))

        // Assert
        await store.receive(\._local.forgotPasswordFailure) {
            $0.forgotPasswordConfirmProgress = .loaded(.failure(.emailHasNotBeenRegistered))
            XCAssertNoDifference(
                $0.forgotPasswordConfirmProgress[case: \.loaded.failure]?.userFriendlyError,
                "Email này không có trong hệ thống của mouka. Vui lòng kiểm tra lại hoặc thử một email khác."
            )
        }
    }

    func testMustReturnError_WhenGenericErrorOccurs() async throws {
        // Arrange
        let store = TestStore(initialState: .init()) {
            ForgotPasswordFeature()
        } withDependencies: {
            $0.authAPIService = .directMock(forgotPasswordMock: """
            {
              "message": "Something's wrong",
              "code": 14006
            }
            """)
        }
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$emailText, "user@mouka.ai"))
        await store.send(.view(.nextButtonTapped))

        // Assert
        await store.receive(\._local.forgotPasswordFailure) {
            XCTAssertTrue($0.forgotPasswordConfirmProgress.is(\.loaded.failure.genericError))
            XCAssertNoDifference(
                $0.forgotPasswordConfirmProgress[case: \.loaded.failure]?.userFriendlyError,
                "Oops! Đã xảy ra sự cố khi đổi mật khẩu. Hãy thử lại sau một chút."
            )
        }
    }

    func testMustReturnError_WhenEmailIsInvalid() async throws {
        // Arrange
        let store = TestStore(initialState: .init()) {
            ForgotPasswordFeature()
        }
        store.exhaustivity = .off

        // Act & Assert
        await store.send(.set(\.$emailText, ""))
        await store.send(.view(.nextButtonTapped))
        await store.receive(\._local.forgotPasswordFailure) {
            $0.forgotPasswordConfirmProgress = .loaded(.failure(.emailInvalid(.fieldEmpty)))
            XCAssertNoDifference(
                $0.forgotPasswordConfirmProgress[case: \.loaded.failure]?.userFriendlyError,
                "Email không hợp lệ."
            )
        }

        await store.send(.set(\.$emailText, "user"))
        await store.send(.view(.nextButtonTapped))
        await store.receive(\._local.forgotPasswordFailure) {
            $0.forgotPasswordConfirmProgress = .loaded(.failure(.emailInvalid(.patternInvalid)))
            XCAssertNoDifference(
                $0.forgotPasswordConfirmProgress[case: \.loaded.failure]?.userFriendlyError,
                "Email không hợp lệ."
            )
        }

        await store.send(.set(\.$emailText, "user@mouka"))
        await store.send(.view(.nextButtonTapped))
        await store.receive(\._local.forgotPasswordFailure) {
            $0.forgotPasswordConfirmProgress = .loaded(.failure(.emailInvalid(.patternInvalid)))
            XCAssertNoDifference(
                $0.forgotPasswordConfirmProgress[case: \.loaded.failure]?.userFriendlyError,
                "Email không hợp lệ."
            )
        }
    }

    func testMustSuccess_WithExpectedRespons() async throws {
        // Arrange
        let store = TestStore(initialState: .init()) {
            ForgotPasswordFeature()
        } withDependencies: {
            $0.authAPIService = .directMock(forgotPasswordMock: """
            {
              "message": "Execute successfully"
            }
            """)
        }
        store.exhaustivity = .off

        // Act
        await store.send(.set(\.$emailText, "user@mouka.ai"))
        await store.send(.view(.nextButtonTapped))

        // Assert
        await store.receive(\._local.forgotPasswordConfirmed) {
            $0.forgotPasswordConfirmProgress = .loaded(.success(Confirmed()))
        }
    }
}
