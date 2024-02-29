//
//  FundPickerReducer.swift
//
//
//  Created by Hien Tran on 27/01/2024.
//

import ComposableArchitecture
import DomainEntities
import Foundation

@Reducer
public struct FundPickerReducer {
    public init() {}
    public struct State: Equatable {
        public init(
            funds: IdentifiedArrayOf<FundEntity>,
            selection: UUID? = nil
        ) {
            self.funds = funds
            self.selectedFund = selection
        }

        let funds: IdentifiedArrayOf<FundEntity>
        var selectedFund: UUID?
    }

    public enum Action {
        case fundSelected(id: UUID)
        case removeSelection
        case saveSelection(id: UUID?)
    }

    @Dependency(\.dismiss) var dismiss

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .fundSelected(id):
                state.selectedFund = id
                return .none
            case .removeSelection:
                state.selectedFund = nil
                return .none
            case .saveSelection:
                return .run { _ in await dismiss() }
            }
        }
    }
}
