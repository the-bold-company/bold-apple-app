import SwiftUI
public enum FireButtonShape: Equatable {
    case capsule
    case roundedCorner
}

public enum FireButtonType: Equatable {
    case primary(shape: FireButtonShape)
    case secondary(shape: FireButtonShape)
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
        case let .secondary(shape):
            switch shape {
            case .capsule:
                return .symetric(horizontal: 8, vertical: 4)
            case .roundedCorner:
                return .all(16)
            }
        case .tertiary:
            return .all(16)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .primary:
            return .coreui.brightGreen
        case .secondary, .tertiary:
            return .white
        }
    }

    var borderColor: Color {
        switch self {
        case .primary:
            return .coreui.brightGreen
        case .secondary:
            return .coreui.forestGreen
        case .tertiary:
            return .white
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
