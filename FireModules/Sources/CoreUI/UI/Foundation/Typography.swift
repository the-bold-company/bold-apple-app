//
//  Typography.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import SwiftUI

public enum Typography {
    case titleScreen
    case titleSection

    var font: FontConvertible {
        switch self {
        case .titleScreen:
            return FontFamily.Inter.semiBold
        case .titleSection:
            return FontFamily.Inter.semiBold
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .titleScreen:
            return 30
        case .titleSection:
            return 26
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .titleScreen:
            return 34
        case .titleSection:
            return 32
        }
    }

    var lineSpacing: CGFloat {
        return lineHeight - fontSize
    }

    var letterSpacing: CGFloat {
        switch self {
        case .titleScreen:
            return -0.025 // -2.5%
        case .titleSection:
            return -0.015 // -1.5%
        }
    }

    var kerning: CGFloat {
        return fontSize * letterSpacing
    }
}

public extension Text {
    func typography(_ typography: Typography) -> some View {
        font(.custom(typography.font, size: typography.fontSize))
            .kerning(typography.kerning)
            .lineSpacing(typography.lineSpacing)
    }
}
