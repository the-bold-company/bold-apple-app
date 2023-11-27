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

    public init(title: String, text: Binding<String>) {
        self.title = title
        _text = text
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom(FontFamily.Inter.regular, size: 14))

            Spacing(height: .size8)

            TextField(
                "",
                text: $text,
                onEditingChanged: { _ in
                },
                onCommit: {}
            )
            .autocapitalization(.none)
            .padding(16)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.coreui.contentPrimary, lineWidth: 1)
            )
        }
        .enableInjection()
    }
}
