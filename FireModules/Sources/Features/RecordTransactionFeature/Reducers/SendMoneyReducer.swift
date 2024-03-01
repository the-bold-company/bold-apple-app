//
//  SendMoneyReducer.swift
//
//
//  Created by Hien Tran on 21/01/2024.
//

import ComposableArchitecture
import Foundation
import FundListUseCase
import TransactionRecordUseCase

@Reducer
public struct SendMoneyReducer {
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
        var transactionRecordLoadingState: LoadingState<TransactionEntity> = .idle

        var sourceFundId: UUID {
            return sourceFund.id
        }

        var destinationFundId: UUID? {
            return selectedTargetFund?.id
        }
    }

    public enum Action: BindableAction {
        case onAppear
        case targetFundsLoaded(IdentifiedArrayOf<FundEntity>)
        case binding(BindingAction<State>)
        case fundPicker(PresentationAction<FundPickerReducer.Action>)
        case delegate(Delegate)

        case transactionRecordedSuccessfully(TransactionEntity)
        case transactionRecordedFailed(DomainError)

        public enum Delegate {
            case fundPickerFieldTapped
            case proceedButtonTapped
        }
    }

    @Dependency(\.dismiss) var dismiss

    let transactionRecordUseCase: TransactionRecordUseCaseProtocol
    let fundListUseCase: FundListUseCaseProtocol

    public init(
        transactionRecordUseCase: TransactionRecordUseCaseProtocol,
        fundListUseCase: FundListUseCaseProtocol
    ) {
        self.transactionRecordUseCase = transactionRecordUseCase
        self.fundListUseCase = fundListUseCase
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.targetFunds.isEmpty else { return .none }
                return .run { [sourceFundId = state.sourceFund.id] send in
                    let result = await fundListUseCase.getFiatFundList()

                    switch result {
                    case var .success(loadedFunds):
                        var selectableFunds = IdentifiedArray(uniqueElements: loadedFunds)
                        selectableFunds.remove(id: sourceFundId)
                        await send(.targetFundsLoaded(selectableFunds))
                    case .failure:
                        // Maybe re-fetch the fund? But practically, it shouldn't goes here
                        break
                    }
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
            case let .transactionRecordedSuccessfully(transaction):
                state.transactionRecordLoadingState = .loaded(transaction)
                return .run { _ in await dismiss() }
            case let .transactionRecordedFailed(err):
                state.transactionRecordLoadingState = .failure(err)
                return .none
            case .delegate(.fundPickerFieldTapped):
                guard !state.targetFunds.isEmpty else { return .none }
                state.fundPicker = .init(funds: state.targetFunds, selection: state.selectedTargetFund?.id)
                return .none
            case .delegate(.proceedButtonTapped):
                state.transactionRecordLoadingState = .loading
                return .run { [sourceID = state.sourceFundId, amount = state.amount, destinationId = state.destinationFundId, description = state.description] send in
                    let result = await transactionRecordUseCase.recordInOutTransaction(
                        sourceFundId: sourceID,
                        amount: Decimal(amount),
                        destinationFundId: destinationId,
                        description: description
                    )
                    switch result {
                    case let .success(recordedTransaction):
                        await send(.transactionRecordedSuccessfully(recordedTransaction))
                    case let .failure(error):
                        await send(.transactionRecordedFailed(error))
                    }
                }
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
