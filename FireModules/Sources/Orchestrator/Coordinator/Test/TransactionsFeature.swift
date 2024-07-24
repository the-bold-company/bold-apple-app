//
//  TransactionsFeature.swift
//
//
//  Created by Hien Tran on 23/07/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct TransactionsFeature {
    public struct State: Equatable {}
    public enum Action {}
    public var reducer: some ReducerOf<Self> {
        EmptyReducer()
    }
}

public struct transactions: View {
    let store: StoreOf<TransactionsFeature>

    public init(store: StoreOf<TransactionsFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("🌮 transactions")
    }
}
