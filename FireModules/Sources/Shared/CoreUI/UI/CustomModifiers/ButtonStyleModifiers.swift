//
//  ButtonStyleModifiers.swift
//
//
//  Created by Hien Tran on 14/01/2024.
//

import SwiftUI

public extension View {
    func fireButtonStyle(type: FireButtonType = .primary(shape: .roundedCorner)) -> some View {
        buttonStyle(FireButtonStyle(buttonType: type))
    }
}
