//
//  ButtonStyles.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import SwiftUI

public enum FireButtonShape: Equatable {
    case capsule
    case roundedCorner
}

public enum FireButtonType: Equatable {
    case primary(shape: FireButtonShape)
    case secondary
    case tertiary

    var padding: EdgeInsets {
        switch self {
        case let .primary(shape):
            switch shape {
            case .capsule:
                return .symetric(horizontal: 8, vertical: 4)
            case .roundedCorner:
                return .all(16)
            }
        case .secondary:
            return .all(16)
        case .tertiary:
            return .all(16)
        }
    }

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

public struct FireButtonStyle: ButtonStyle {
    public init(buttonType: FireButtonType = .primary(shape: .roundedCorner)) {
        self.buttonType = buttonType
    }

    let buttonType: FireButtonType

    public func makeBody(configuration: FireButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.custom(FontFamily.Inter.semiBold, size: 14))
            .foregroundColor(buttonType.foregroundColor)
            .padding(buttonType.padding)
            .if(.primary(shape: .capsule) == buttonType) {
                $0.background(Capsule(style: .circular).fill(buttonType.backgroundColor))
            }
            .if(.primary(shape: .capsule) != buttonType) {
                $0.background(RoundedRectangle(cornerRadius: 8).fill(buttonType.backgroundColor))
            }
            .compositingGroup()
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
