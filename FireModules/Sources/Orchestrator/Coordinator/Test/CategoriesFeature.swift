//
//  CategoriesFeature.swift
//
//
//  Created by Hien Tran on 23/07/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategoriesFeature {
    public struct State: Equatable {}
    public enum Action {}
    public var reducer: some ReducerOf<Self> {
        EmptyReducer()
    }
}

public struct categories: View {
    let store: StoreOf<CategoriesFeature>

    public init(store: StoreOf<CategoriesFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("🌮 categories")
    }
}
