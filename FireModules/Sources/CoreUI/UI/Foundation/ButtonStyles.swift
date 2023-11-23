//
//  ButtonStyles.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import SwiftUI

public enum FireButtonType {
    case primary
    case secondary
    case tertiary

    var backgroundColor: Color {
        switch self {
        case .primary:
            return .coreui.brightGreen
        case .secondary, .tertiary:
            return .clear
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary, .secondary:
            return .coreui.forestGreen
        case .tertiary:
            return .coreui.contentPrimary
        }
    }
}

struct FireButtonModifier: ViewModifier {
    let buttonType: FireButtonType

    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.Inter.semiBold, size: 14))
            .foregroundColor(buttonType.foregroundColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(buttonType.backgroundColor)
            .cornerRadius(8)
    }
}

public extension View {
    func fireButtonStyle(type: FireButtonType = .primary) -> some View {
        modifier(FireButtonModifier(buttonType: type))
    }
}
