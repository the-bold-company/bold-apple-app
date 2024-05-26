//
//  ButtonStyleModifiers.swift
//
//
//  Created by Hien Tran on 14/01/2024.
//

import SwiftUI

public extension View {
    func fireButtonStyle(type: FireButtonType = .primary(shape: .roundedCorner), isActive: Bool = true) -> some View {
        buttonStyle(FireButtonStyle(buttonType: type, isActive: isActive))
    }

    func secondaryButtomCustomBorderStyle(
        shape: FireButtonShape = .roundedCorner,
        borderColor: Color,
        backgroundColor: Color? = nil,
        textColor: Color? = nil,
        isActive: Bool = true
    ) -> some View {
        buttonStyle(SecondaryCustomBorderStyle(shape: shape, borderColor: borderColor, backgroundColor: backgroundColor, textColor: textColor, isActive: isActive))
    }
}
