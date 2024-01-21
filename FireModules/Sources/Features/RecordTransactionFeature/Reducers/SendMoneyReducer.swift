//
//  SendMoneyReducer.swift
//
//
//  Created by Hien Tran on 21/01/2024.
//

import ComposableArchitecture
import Foundation
import SharedServices

@Reducer
public struct SendMoneyReducer {
    public init() {}

    public struct State: Equatable {
        public init(sourceFund: FundEntity) {
            self.sourceFund = sourceFund
            self.description = "Transfer from '\(sourceFund.name)'"
        }

        let sourceFund: FundEntity
        var targetFunds: IdentifiedArrayOf<FundEntity> = [] // TODO: Make it possible to set once
        var selectedTargetFund: FundEntity?
        @BindingState var amount: Int = 0
        @BindingState var description: String = ""
        @PresentationState var fundPicker: FundPickerReducer.State?
        var isFormValid = false
    }

    public enum Action: BindableAction {
        case onAppear
        case targetFundsLoaded(IdentifiedArrayOf<FundEntity>)
        case binding(BindingAction<State>)
        case fundPicker(PresentationAction<FundPickerReducer.Action>)
        case delegate(Delegate)

        public enum Delegate {
            case fundPickerFieldTapped
        }
    }

    @Dependency(\.authGuardService) var authGuardService

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.targetFunds.isEmpty else { return .none }
                return .run { [sourceFundId = state.sourceFund.id] send in
                    let loadedFunds = await authGuardService.loadedFunds()
                    var possibleTargetFunds = IdentifiedArray(uniqueElements: loadedFunds)
                    possibleTargetFunds.remove(id: sourceFundId)
                    await send(.targetFundsLoaded(possibleTargetFunds))
                }
            case let .targetFundsLoaded(targetFunds):
                state.targetFunds = targetFunds
                return .none
            case let .fundPicker(.presented(.saveSelection(id))):
                state.selectedTargetFund = id != nil
                    ? state.targetFunds[id: id!] // swiftlint:disable:this force_unwrapping
                    : nil

                if let targetFund = state.selectedTargetFund {
                    state.description += " to '\(targetFund.name)'"
                } else {
                    state.description = "Transfer from '\(state.sourceFund.name)'"
                }

                return .none
            case .delegate(.fundPickerFieldTapped):
                guard !state.targetFunds.isEmpty else { return .none }
                state.fundPicker = .init(funds: state.targetFunds, selection: state.selectedTargetFund?.id)
                return .none
            case .binding:
                state.isFormValid = validateForm(currentState: state)
                return .none
            case .delegate, .fundPicker:
                return .none
            }
        }
        .ifLet(\.$fundPicker, action: \.fundPicker) {
            FundPickerReducer()
        }
    }

    private func validateForm(currentState: State) -> Bool {
        return currentState.amount > 0 && Decimal(currentState.amount) <= currentState.sourceFund.balance
    }
}
