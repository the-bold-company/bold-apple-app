//
//  FundCreationPage.swift
//
//
//  Created by Hien Tran on 11/01/2024.
//

import ComposableArchitecture
import CoreUI
import CurrencyKit
import FundCreationUseCase
import SwiftUI

public struct FundCreationPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        @BindingViewState var fundName: String
        @BindingViewState var description: String
        @BindingViewState var balance: Int
        var isLoading: Bool
    }

    let store: StoreOf<FundCreationReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, FundCreationReducer.Action>

    public init(store: StoreOf<FundCreationReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.isLoading) {
            VStack(alignment: .leading) {
                DismissButton()
                Spacing(size: .size8)
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        Text("Create your fund")
                            .typography(.titleScreen)
                        fundNameInputField
                        balanceFieldInput
                        descriptionInputField
                        Spacing(size: .size24)
                    }
                }
                .scrollDismissesKeyboard(.interactively)

                Spacer()
                Button(action: {
                    viewStore.send(.forward(.submitButtonTapped))
                }) {
                    HStack {
                        Text("Create fund")
                            .frame(maxWidth: .infinity)
                    }
                }
                .fireButtonStyle()
            }
            .hideNavigationBar()
            .padding()
        }
        .enableInjection()
    }

    @ViewBuilder
    private var fundNameInputField: some View {
        FireTextField(
            title: "Name your fund",
            text: viewStore.$fundName
        )
        .autocorrectionDisabled()
        #if os(iOS)
            .textInputAutocapitalization(.sentences)
        #endif
    }

    @ViewBuilder
    private var balanceFieldInput: some View {
        VStack(alignment: .leading) {
            Text("Balance").typography(.bodyDefault)
            Spacing(height: .size8)
            HStack {
                Button(action: {
                    // Action to perform when the button is tapped
                }) {
                    HStack {
                        Text("VND").typography(.bodyDefault)
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 8, height: 8)
                    }
                }
                .fireButtonStyle(type: .primary(shape: .capsule))

                #if os(iOS)
                CurrencyField(value: viewStore.$balance)
                #endif

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.coreui.contentPrimary, lineWidth: 1)
            )
        }
    }

    @ViewBuilder
    private var descriptionInputField: some View {
        VStack(alignment: .leading) {
            Text("Description").typography(.bodyDefault)
            Spacing(height: .size8)
            TextEditor(text: viewStore.$description)
                .autocorrectionDisabled()
            #if os(iOS)
                .textInputAutocapitalization(.sentences)
            #endif
                .multilineTextAlignment(.leading)
                .frame(height: 100.0)
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .padding(.symetric(horizontal: 16, vertical: 8))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.coreui.contentPrimary, lineWidth: 1)
                )
        }
    }
}

extension BindingViewStore<FundCreationReducer.State> {
    var viewState: FundCreationPage.ViewState {
        // swiftformat:disable redundantSelf
        FundCreationPage.ViewState(
            fundName: self.$fundName,
            description: self.$description,
            balance: self.$balance,
            isLoading: self.loadingState.isLoading
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    FundCreationPage(store: Store(
        initialState: .init(),
        reducer: {
            FundCreationReducer(
                fundCreationUseCase: FundCreationUseCaseProtocolMock()
            )
        }
    ))
}
