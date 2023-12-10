//
//  DismissButton.swift
//
//
//  Created by Hien Tran on 21/11/2023.
//

import SwiftUI

public typealias DismissalHandler = () -> Void

public struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss

    let dismissalHandler: DismissalHandler?

    public init(dismissalHandler: DismissalHandler? = nil) {
        self.dismissalHandler = dismissalHandler
    }

    public var body: some View {
        Button(action: {
            dismissalHandler?()
            dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(Color.coreui.forestGreen)
                .padding(.all(10))
                .background(Color.coreui.forestGreen.opacity(0.14))
                .clipShape(Circle())
        }
    }
}
