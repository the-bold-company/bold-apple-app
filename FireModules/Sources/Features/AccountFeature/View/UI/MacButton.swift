import CoreUI
import SwiftUI

public struct MacButton<Label>: View where Label: View {
    let action: () -> Void
    @ViewBuilder let label: () -> Label
    let type: MoukaButtonType
    let disabled: Bool
    let loading: Bool

    private init(
        type: MoukaButtonType,
        disabled: Bool,
        loading: Bool,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.type = type
        self.disabled = disabled
        self.loading = loading
        self.action = action
        self.label = label
    }

    public static func primary(
        disabled: Bool = false,
        loading: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) -> Self {
        .init(type: .primary, disabled: disabled, loading: loading, action: action, label: label)
    }

    public static func secondary(
        disabled: Bool = false,
        loading: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) -> Self {
        .init(type: .secondary, disabled: disabled, loading: loading, action: action, label: label)
    }

    public static func tertiary(
        disabled: Bool = false,
        loading: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) -> Self {
        .init(type: .tertiary, disabled: disabled, loading: loading, action: action, label: label)
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                HStack {
                    Spacer()
                    Rectangle()
                        .frame(width: 0, height: 0)
                }
                .frame(idealWidth: .infinity)

                label()
                    .layoutPriority(1000)

                HStack {
                    if type != .tertiary, loading, !disabled {
                        ProgressView()
                            .controlSize(.small)
                    }
                    Spacer()
                    Rectangle()
                        .frame(width: 0, height: 0)
                }
                .frame(idealWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(_MacButtonStyle(type, disabled: loading || disabled))
    }
}

private struct _MacButtonStyle: ButtonStyle {
    public init(_ buttonType: MoukaButtonType = .primary, disabled: Bool = false) {
        self.buttonType = buttonType
        self.disabled = disabled
    }

    @State private var isHovered = false
    let buttonType: MoukaButtonType
    let disabled: Bool

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.symetric(horizontal: 14, vertical: 8))
            .font(.custom(FontFamily.Inter.semiBold, size: 12))
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
    WithState(initialValue: (false, false)) { $state in
        VStack(spacing: 20) {
            Toggle(isOn: $state.0) {
                Text("Disabled?")
            }

            Toggle(isOn: $state.1) {
                Text("Loading?")
            }

            MacButton.primary(
                disabled: state.0,
                loading: state.1,
                action: {},
                label: {
                    Text("Primary button") // .frame(maxWidth: .infinity)
                }
            )

            MacButton.secondary(
                disabled: state.0,
                loading: state.1,
                action: {},
                label: {
                    Text("Primary button") // .frame(maxWidth: .infinity)
                }
            )

            MacButton.tertiary(
                disabled: state.0,
                loading: state.1,
                action: {},
                label: {
                    Text("Tertiary button").frame(maxWidth: .infinity)
                }
            )
        }
        .frame(width: 300)
        .padding(40)
        .background(Color.white)
    }
    .preferredColorScheme(.light)
}
