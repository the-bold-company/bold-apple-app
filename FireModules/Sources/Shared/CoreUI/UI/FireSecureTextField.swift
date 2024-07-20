//
//  FireSecureTextField.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import Inject
import SwiftUI

public struct FireSecureTextField: View {
    @ObserveInjection private var iO

    @Binding private var text: String
    @State private var isSecureTextEntry = true
    private let placeholder: LocalizedStringKey?

    let title: String

    public init(_ placeholder: LocalizedStringKey? = nil, title: String, text: Binding<String>) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title).typography(.bodyDefault)

            Spacing(height: .size8)

            HStack {
                // TODO: FInd another way to do this because every time `isSecureTextEntry` changes, the TextField will be redrawn
                if isSecureTextEntry {
                    SecureField(
                        placeholder ?? "",
                        text: $text,
                        onCommit: {}
                    )
                    .padding([.leading, .bottom, .top], 16)
                } else {
                    TextField(
                        "",
                        text: $text,
                        onCommit: {}
                    )
                    .padding([.leading, .bottom, .top], 16)
                }

                Spacing(width: .size8)

                Button {
                    isSecureTextEntry.toggle()
                } label: {
                    Image(systemName: isSecureTextEntry ? "eye.slash" : "eye")
                        .foregroundColor(.coreui.contentPrimary)
                }
                .buttonStyle(.plain)
                .frame(width: 24, height: 24)
            }
            .padding([.trailing], 16)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.coreui.contentPrimary, lineWidth: 1)
            )
        }
        .enableInjection()
    }
}
