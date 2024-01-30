//
//  LoggedInUserService.swift
//
//
//  Created by Hien Tran on 24/01/2024.
//

import Dependencies
import Foundation
@_exported import SharedModels

public struct LoggedInUserService {
    public var loadedFunds: @Sendable () async -> [FundEntity] = { [] }
    public var updateLoadedFunds: @Sendable ([FundEntity]) async -> Void
    public var logout: @Sendable () async -> Void
}

extension LoggedInUserService: DependencyKey {
    public static var liveValue = LoggedInUserService.live
    public static var testValue = LoggedInUserService.mock()
}

public extension DependencyValues {
    var loggedInUserService: LoggedInUserService {
        get { self[LoggedInUserService.self] }
        set { self[LoggedInUserService.self] = newValue }
    }
}

extension LoggedInUserService {
    public static var live: LoggedInUserService {
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
        return Self(
            loadedFunds: { await authData.loadedFunds },
            updateLoadedFunds: { await authData.setLoadedFunds(funds: $0) },
            logout: { await authData.cleanUp() }
        )
    }

    static func mock() -> LoggedInUserService {
        return Self(
            loadedFunds: { [] },
            updateLoadedFunds: { _ in },
            logout: {}
        )
    }
}
