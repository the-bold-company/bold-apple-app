public enum MoukaButtonType: Equatable {
    case primary
    case secondary
    case tertiary

    var padding: EdgeInsets {
        switch self {
        case .primary, .secondary:
            return .all(14)
        case .tertiary:
            return .zero
        }
    }

    var defaultBackgroundColor: Color {
        switch self {
        case .primary:
            return .coreui.brightGreen
        case .secondary:
            return .white
        case .tertiary:
            return .clear
        }
    }

    var hoverBackgroundColor: Color {
        switch self {
        case .primary:
            return .init(hex: 0x8BD958)
        case .secondary:
            return .init(hex: 0xF8FAFC)
        case .tertiary:
            return .clear
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary: .coreui.forestGreen
        case .secondary: .init(hex: 0x1F2937)
        case .tertiary: .init(hex: 0x5F9F2F)
        }
    }

    var disabledForegroundColor: Color {
        switch self {
        case .primary, .secondary: .init(hex: 0xD1D5DB)
        case .tertiary: foregroundColor
        }
    }

    var disabledBackgroundColor: Color {
        switch self {
        case .primary, .secondary: .init(hex: 0xF3F4F6)
        case .tertiary: defaultBackgroundColor
        }
    }

    var borderColor: Color? {
        switch self {
        case .primary, .tertiary: nil
        case .secondary: .init(hex: 0xE5E7EB)
        }
    }

    var disabledBorderColor: Color? {
        switch self {
        case .primary, .tertiary: nil
        case .secondary: .init(hex: 0xF3F4F6)
        }
    }
}

public struct MoukaButtonStyle: ButtonStyle {
    public init(_ buttonType: MoukaButtonType = .primary, disabled: Bool = false) {
        self.buttonType = buttonType
        self.disabled = disabled
    }

    @State private var isHovered = false
    let buttonType: MoukaButtonType
    let disabled: Bool

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(buttonType.padding)
            .font(.custom(FontFamily.Inter.semiBold, size: 14))
            .foregroundColor(disabled
                ? buttonType.disabledForegroundColor
                : buttonType.foregroundColor
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(disabled
                        ? buttonType.disabledBackgroundColor
                        : isHovered || configuration.isPressed
                        ? buttonType.hoverBackgroundColor
                        : buttonType.defaultBackgroundColor
                    )
            )
            .if(buttonType == .secondary) {
                $0.overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            disabled
                                ? buttonType.disabledBorderColor!
                                : buttonType.borderColor!,
                            lineWidth: 1
                        )
                }
            }
            .if(buttonType == .secondary && !disabled) {
                $0.shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 0)
            }
            .compositingGroup()
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .onHover { isHovered = $0 }
            .disabled(disabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        Button {} label: {
            Text("Primary button")
        }
        .buttonStyle(MoukaButtonStyle())

        Button {} label: {
            Text("Primary button")
        }
        .buttonStyle(MoukaButtonStyle(disabled: true))

        Button {} label: {
            Text("Secondary button")
        }
        .buttonStyle(MoukaButtonStyle(.secondary))

        Button {} label: {
            Text("Secondary button")
        }
        .buttonStyle(MoukaButtonStyle(.secondary, disabled: true))
    }
    .padding()
    .background(Color.white)
//    .background(Color(hex: 0xB7F2C0))
}
