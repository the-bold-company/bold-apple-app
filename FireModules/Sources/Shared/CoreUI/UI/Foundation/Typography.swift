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
    case titleSubsection
    case titleBody
    case titleGroup
    case titleSmall
    case bodyLarge
    case bodyLargeBold
    case bodyDefault
    case bodyDefaultBold
    case linkLarge
    case linkDefault

    public var font: FontConvertible {
        switch self {
        case .titleScreen, .titleSection, .titleSubsection, .titleBody,
             .bodyLargeBold, .bodyDefaultBold,
             .linkLarge, .linkDefault:
            return FontFamily.Inter.semiBold
        case .titleGroup:
            return FontFamily.Inter.medium
        case .bodyLarge, .bodyDefault, .titleSmall:
            return FontFamily.Inter.regular
        }
    }

    public var fontSize: CGFloat {
        switch self {
        case .titleScreen:
            return 30
        case .titleSection:
            return 26
        case .titleSubsection:
            return 22
        case .titleBody:
            return 18
        case .titleGroup, .bodyDefault, .bodyDefaultBold, .linkDefault:
            return 14
        case .bodyLarge, .bodyLargeBold, .linkLarge:
            return 16
        case .titleSmall:
            return 12
        }
    }

    public var lineHeight: CGFloat {
        switch self {
        case .titleScreen:
            return 34
        case .titleSection:
            return 32
        case .titleSubsection:
            return 28
        case .titleBody, .bodyLarge, .bodyLargeBold, .linkLarge:
            return 24
        case .titleGroup:
            return 20
        case .bodyDefault, .bodyDefaultBold, .linkDefault:
            return 22
        case .titleSmall:
            return 16
        }
    }

    public var lineSpacing: CGFloat {
        return lineHeight - fontSize
    }

    public var letterSpacing: CGFloat {
        switch self {
        case .titleScreen:
            return -0.025 // -2.5%
        case .titleSection, .titleSubsection, .titleGroup:
            return -0.015 // -1.5%
        case .titleBody, .bodyDefault, .linkLarge:
            return -0.01 // -1%
        case .bodyLarge, .bodyLargeBold:
            return -0.005 // -0.5%
        case .bodyDefaultBold, .linkDefault, .titleSmall:
            return -0.00125 // -1.25%
        }
    }

    var kerning: CGFloat {
        return fontSize * letterSpacing
    }
}
