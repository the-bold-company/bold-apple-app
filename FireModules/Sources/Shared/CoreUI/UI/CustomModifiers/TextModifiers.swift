//
//  TextModifiers.swift
//
//
//  Created by Hien Tran on 14/01/2024.
//

import SwiftUI

public extension Text {
    func typography(_ typography: Typography) -> some View {
        font(.custom(typography.font, size: typography.fontSize))
            .kerning(typography.kerning)
            .lineSpacing(typography.lineSpacing)
    }
}
