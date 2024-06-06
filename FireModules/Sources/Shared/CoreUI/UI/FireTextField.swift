//
//  FireTextField.swift
//
//
//  Created by Hien Tran on 22/11/2023.
//

import Inject
import SwiftUI

public struct FireTextField: View {
    @ObserveInjection private var iO

    @Binding private var text: String
    let title: String
    let placeholder: LocalizedStringKey?

    public init(_ placeholder: LocalizedStringKey? = nil, title: String, text: Binding<String>) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title).typography(.bodyDefault)

            Spacing(height: .size8)

            TextField(
                placeholder ?? "",
                text: $text,
                onEditingChanged: { _ in
                },
                onCommit: {}
            )
            .autocapitalization(.none)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.coreui.contentPrimary, lineWidth: 1)
            )
        }
        .enableInjection()
    }
}
