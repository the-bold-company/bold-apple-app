//
//  SendMoneyPage.swift
//
//
//  Created by Hien Tran on 21/01/2024.
//

import ComposableArchitecture
import CoreUI
import CurrencyKit
import DomainEntities
import SwiftUI

public struct SendMoneyPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        let sourceFund: FundEntity
        var targetFunds: IdentifiedArrayOf<FundEntity>
        var selectedTargetFund: FundEntity?
        @BindingViewState var amount: Int
        @BindingViewState var description: String
        var isLoading: Bool
        var isFormValid: Bool
    }

    private let store: StoreOf<SendMoneyReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, SendMoneyReducer.Action>

    public init(store: StoreOf<SendMoneyReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.isLoading) {
            VStack(alignment: .leading) {
                DismissButton().padding(.leading, 16)
                VStack {
                    ScrollView {
                        VStack {
                            amountInput
                            fundPicker
                            descriptionInput
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)

                    Spacer()
                    proceedButton
                }
                .frame(maxHeight: .infinity)
            }
            .task {
                viewStore.send(.forward(.onAppear))
            }
            .navigationBarHidden(true)
            .sheet(
                store: store.scope(
                    state: \.$fundPicker,
                    action: \.fundPicker
                )
            ) { FundPickerPage(store: $0) }
        }
        .enableInjection()
    }

    @ViewBuilder
    private var amountInput: some View {
        ZStack(alignment: .center) {
            CurrencyField(value: viewStore.$amount)
                .font(.custom(FontFamily.Inter.semiBold, size: 36))
                .alignmentGuide(VerticalAlignment.center, computeValue: { dimension in dimension[VerticalAlignment.center] })
            Button(action: {
                // Action to perform when the button is tapped
            }) {
                Text("VND")
            }
            .fireButtonStyle(type: .secondary(shape: .capsule))
            .alignmentGuide(VerticalAlignment.center, computeValue: { dimension in dimension[VerticalAlignment.center] - 48 })

            Text("Current balance: \(CurrencyKit.shared.currencyString(for: viewStore.sourceFund.balance, isoCurrencyCode: viewStore.sourceFund.currency))")
                .foregroundColor(.coreui.darkCharcoal)
                .typography(.bodyDefault)
                .alignmentGuide(VerticalAlignment.center, computeValue: { dimension in dimension[VerticalAlignment.center] - 72 })
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var fundPicker: some View {
        VStack(alignment: .leading) {
            Text("Destination Fund").typography(.bodyDefault)
            Spacing(height: .size8)
            Button(action: {
                viewStore.send(.forward(.fundPickerFieldTapped))
            }) {
                HStack {
                    Text(viewStore.selectedTargetFund?.name ?? "None").typography(.bodyDefault)
                    Spacer()
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 8, height: 8)
                }
            }
            .fireButtonStyle(type: .secondary(shape: .roundedCorner))
        }
        .padding([.leading, .trailing], 16)
    }

    @ViewBuilder
    private var descriptionInput: some View {
        VStack(alignment: .leading) {
            Text("Description").typography(.bodyDefault)
            Spacing(height: .size8)
            TextEditor(text: viewStore.$description)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.sentences)
                .multilineTextAlignment(.leading)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .padding(.symetric(horizontal: 12, vertical: 8))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.coreui.contentPrimary, lineWidth: 1)
                )
        }
        .padding([.leading, .trailing], 16)
    }

    @ViewBuilder
    private var proceedButton: some View {
        VStack {
            Button(action: {
                viewStore.send(.forward(.proceedButtonTapped))
            }) {
                HStack {
                    Text("Proceed")
                        .frame(maxWidth: .infinity)
                }
            }
            .fireButtonStyle()
            .disabled(!viewStore.isFormValid)
        }
        .padding([.leading, .trailing], 16)
    }
}

extension BindingViewStore<SendMoneyReducer.State> {
    var viewState: SendMoneyPage.ViewState {
        // swiftformat:disable redundantSelf
        SendMoneyPage.ViewState(
            sourceFund: self.sourceFund,
            targetFunds: self.targetFunds,
            selectedTargetFund: self.selectedTargetFund,
            amount: self.$amount,
            description: self.$description,
            isLoading: self.transactionRecordLoadingState.isLoading,
            isFormValid: self.isFormValid
        )
        // swiftformat:enable redundantSelf
    }
}
