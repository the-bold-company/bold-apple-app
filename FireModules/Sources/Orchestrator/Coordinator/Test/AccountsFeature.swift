//
//  AccountsFeature.swift
//
//
//  Created by Hien Tran on 23/07/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct AccountsFeature {
    public struct State: Equatable {}
    public enum Action {}
    public var reducer: some ReducerOf<Self> {
        EmptyReducer()
    }
}

public struct accounts: View {
    let store: StoreOf<AccountsFeature>

    public init(store: StoreOf<AccountsFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("🌮 accounts")
    }
}
