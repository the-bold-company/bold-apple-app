//
//  ReportFeature.swift
//
//
//  Created by Hien Tran on 23/07/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct ReportFeature {
    public struct State: Equatable {}
    public enum Action {}
    public var reducer: some ReducerOf<Self> {
        EmptyReducer()
    }
}

public struct reports: View {
    let store: StoreOf<ReportFeature>

    public init(store: StoreOf<ReportFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("🌮 reports")
    }
}
