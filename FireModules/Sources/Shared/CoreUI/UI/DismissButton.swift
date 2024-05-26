//
//  DismissButton.swift
//
//
//  Created by Hien Tran on 21/11/2023.
//

import SwiftUI

public typealias DismissalHandler = () -> Void

public struct DismissButton<Label>: View where Label: View {
    @Environment(\.dismiss) private var dismiss

    private let label: () -> Label
    private let dismissalHandler: DismissalHandler?

    public init(
        @ViewBuilder label: @escaping () -> Label,
        dismissalHandler: DismissalHandler? = nil
    ) {
        self.label = label
        self.dismissalHandler = dismissalHandler
    }

    public init(
        @ViewBuilder image: @escaping () -> Image,
        dismissalHandler: DismissalHandler? = nil
    ) where Label == AnyView {
        self.label = {
            AnyView(
                image()
                    .foregroundColor(Color.coreui.forestGreen)
                    .padding(.all(10))
                    .background(Color.coreui.forestGreen.opacity(0.14))
                    .clipShape(Circle())
            )
        }
        self.dismissalHandler = dismissalHandler
    }

    public init(dismissalHandler: DismissalHandler? = nil) where Label == AnyView {
        self.init(
            label: {
                AnyView(
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.coreui.forestGreen)
                        .padding(.all(10))
                        .background(Color.coreui.forestGreen.opacity(0.14))
                        .clipShape(Circle())
                )
            },
            dismissalHandler: dismissalHandler
        )
    }

    public var body: some View {
        Button(action: {
            dismissalHandler?()
            dismiss()
        }) {
            if let image = label() as? Image {
                image
                    .foregroundColor(Color.coreui.forestGreen)
                    .padding(.all(10))
                    .background(Color.coreui.forestGreen.opacity(0.14))
                    .clipShape(Circle())
            } else {
                label()
            }
        }
    }
}
