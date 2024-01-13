//
//  FundCreationPage.swift
//
//
//  Created by Hien Tran on 11/01/2024.
//

import CoreUI
import CurrencyKit
import SwiftUI

public struct FundCreationView: View {
    @ObserveInjection private var iO

    @State private var text: Int = 0
    @State private var des: String = ""

    public init() {}

    public var body: some View {
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
                }
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .padding()
        .enableInjection()
    }

    @ViewBuilder
    private var fundNameInputField: some View {
        FireTextField(
            title: "Name your fund",
            text: .constant("")
        )
    }

    @ViewBuilder
    private var balanceFieldInput: some View {
        VStack(alignment: .leading) {
            Text("Balance").typography(.bodyDefault)
            Spacing(height: .size8)
            HStack {
                Button(action: {
                    // Action to perform when the button is tapped
//                    print(currencyFormatter.locale)
                }) {
                    HStack {
                        Text("VND").typography(.bodyDefault)
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 8, height: 8)
                    }
                }
                .fireButtonStyle(type: .primary(shape: .capsule))

                CurrencyField(value: $text)
            }
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
            TextEditor(text: $des)
                .multilineTextAlignment(.leading)
                .frame(width: .infinity, height: 100.0)
                .cornerRadius(10)
                .padding(.symetric(horizontal: 16, vertical: 8))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.coreui.contentPrimary, lineWidth: 1)
                )
        }
    }
}

#Preview {
    FundCreationView()
}
