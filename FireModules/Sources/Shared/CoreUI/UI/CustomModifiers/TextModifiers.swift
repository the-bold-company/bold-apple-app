//
//  TextModifiers.swift
//
//
//  Created by Hien Tran on 14/01/2024.
//

import SwiftUI

public extension Text {
    func typography(_ typography: Typography, ignoreLineSpacing: Bool = false) -> some View {
        font(.custom(typography.font, size: typography.fontSize))
            .kerning(typography.kerning)
            .if(!ignoreLineSpacing) {
                $0.lineSpacing(typography.lineSpacing)
            }
    }
}
