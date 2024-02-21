//
//  LogInReducerTests.swift
//
//
//  Created by Hien Tran on 20/02/2024.
//

import XCTest

import ComposableArchitecture
import DevSettingsUseCases
@testable import LogInFeature
import TestHelpers

// extension DependencyValues {
//    fileprivate mutating func setUpMock() {
//    self.apiClient.baseUrl = { URL(string: "http://localhost:9876")! }
//    self.apiClient.currentPlayer = { .some(.init(appleReceipt: .mock, player: .blob)) }
//    self.build.number = { 42 }
//    self.mainQueue = .immediate
//    self.fileClient.save = { @Sendable _, _ in }
//    self.storeKit.fetchProducts = { _ in
//      .init(invalidProductIdentifiers: [], products: [])
//    }
//    self.storeKit.observer = { .finished }
//    self.userSettings = .mock()
//    }
// }

@MainActor
final class LogInReducerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUsernameAndPassword_isPreFilled_whenDevSettingsAreSet() async throws {
        // Arrange
        let store = TestStore(
            initialState: LoginReducer.State(),
            reducer: { LoginReducer() },
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
            reducer: { LoginReducer() }
        )

        // Act
//        var expectedState = LoginReducer.State()
//        expectedState.email = "user@fire.coms"
//        expectedState.password = "P@ssword123"

        // Assert
        XCAssertTCAStateNoDifference(store.state, LoginReducer.State())
    }
}
