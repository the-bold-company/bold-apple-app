//
//  FireButtonStyles.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import SwiftUI

public struct FireButtonStyle: ButtonStyle {
    public init(buttonType: FireButtonType = .primary(shape: .roundedCorner), isActive: Bool) {
        self.buttonType = buttonType
        self.isActive = isActive
    }

    let buttonType: FireButtonType
    let isActive: Bool

    public func makeBody(configuration: FireButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.custom(FontFamily.Inter.semiBold, size: 14))
            .foregroundColor(buttonType.foregroundColor.foregroundOpacity(isActive: isActive))
            .padding(buttonType.padding)

            .if(buttonType == .primary(shape: .capsule) || buttonType == .secondary(shape: .capsule)) {
                $0.background(
                    Capsule(style: .circular)
                        .fill(
                            buttonType.backgroundColor
                                .backgroundOpacity(isActive: isActive, isPressed: configuration.isPressed)
                        )
                )
            }
            .if(buttonType != .primary(shape: .capsule) && buttonType != .secondary(shape: .capsule)) {
                $0.background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            buttonType.backgroundColor
                                .backgroundOpacity(isActive: isActive, isPressed: configuration.isPressed)
                        )
                )
            }
            .if(buttonType == .primary(shape: .roundedCorner) || buttonType == .secondary(shape: .roundedCorner)) {
                $0.overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            buttonType.borderColor
                                .backgroundOpacity(isActive: isActive, isPressed: configuration.isPressed),
                            lineWidth: 1
                        )
                }
            }
            .if(buttonType == .primary(shape: .capsule) || buttonType == .secondary(shape: .capsule)) {
                $0.overlay {
                    Capsule()
                        .stroke(
                            buttonType.borderColor
                                .backgroundOpacity(isActive: isActive, isPressed: configuration.isPressed),
                            lineWidth: 1
                        )
                }
            }
            .compositingGroup()
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension Color {
    func backgroundOpacity(isActive: Bool, isPressed: Bool) -> Color {
        if isActive {
            return opacity(isPressed ? 0.8 : 1)
        } else {
            return opacity(0.3)
        }
    }

    func foregroundOpacity(isActive: Bool) -> Color {
        if isActive {
            return opacity(1)
        } else {
            return opacity(0.3)
        }
    }
}
