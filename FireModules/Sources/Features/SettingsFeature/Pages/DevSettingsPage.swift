//
//  DevSettingsPage.swift
//
//
//  Created by Hien Tran on 20/01/2024.
//

import ComposableArchitecture
import Inject
import SwiftUI

public struct DevSettingsPage: View {
    @ObserveInjection private var io

    private let store: StoreOf<DevSettingsReducer>

    public init(store: StoreOf<DevSettingsReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            DevSettingsViewWrapper(devSettings: viewStore.$settings)
        }
        .enableInjection()
    }
}
