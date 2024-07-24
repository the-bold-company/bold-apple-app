//
//  OverviewFeature.swift
//
//
//  Created by Hien Tran on 23/07/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct OverviewFeature {
    public struct State: Equatable {}
    public enum Action {}
    public var reducer: some ReducerOf<Self> {
        EmptyReducer()
    }
}

public struct overview: View {
    let store: StoreOf<OverviewFeature>

    public init(store: StoreOf<OverviewFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("🌮 overview")
    }
}
