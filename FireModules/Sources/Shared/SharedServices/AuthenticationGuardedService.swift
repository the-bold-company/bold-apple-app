//
//  AuthenticationGuardedService.swift
//
//
//  Created by Hien Tran on 24/01/2024.
//

import Dependencies
import Foundation
import SharedModels
import SwiftUI

public struct AuthenticationGuardedService {
    public var loadedFunds: @Sendable () async -> [FundEntity] = { [] }
    public var updateLoadedFunds: @Sendable ([FundEntity]) async -> Void
    public var logout: @Sendable () async -> Void
}

extension AuthenticationGuardedService: DependencyKey {
    public static var liveValue = AuthenticationGuardedService.live
    public static var testValue = AuthenticationGuardedService.mock()
}

public extension DependencyValues {
    var authGuardService: AuthenticationGuardedService {
        get { self[AuthenticationGuardedService.self] }
        set { self[AuthenticationGuardedService.self] = newValue }
    }
}

extension AuthenticationGuardedService {
    public static var live: AuthenticationGuardedService {
        actor AuthenticatedData {
            var loadedFunds: [FundEntity]

            init(loadedFunds: [FundEntity]) {
                self.loadedFunds = loadedFunds
            }

            func setLoadedFunds(funds: [FundEntity]) {
                loadedFunds = funds
            }

            func cleanUp() {
                loadedFunds = []
            }
        }

        let authData = AuthenticatedData(loadedFunds: [])
        return AuthenticationGuardedService(
            loadedFunds: { await authData.loadedFunds },
            updateLoadedFunds: { await authData.setLoadedFunds(funds: $0) },
            logout: { await authData.cleanUp() }
        )
    }

    static func mock() -> AuthenticationGuardedService {
        return AuthenticationGuardedService(
            loadedFunds: { [] },
            updateLoadedFunds: { _ in },
            logout: {}
        )
    }
}
