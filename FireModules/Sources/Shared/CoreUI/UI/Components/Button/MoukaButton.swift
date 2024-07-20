import SwiftUI

public struct MoukaButton<Label>: View where Label: View {
    let action: () -> Void
    @ViewBuilder let label: () -> Label
    let type: MoukaButtonType
    let disabled: Bool
    let loading: Bool

    init(
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
        .moukaButtonStyle(type, disabled: loading || disabled)
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

            MoukaButton.primary(
                disabled: state.0,
                loading: state.1,
                action: {},
                label: {
                    Text("Primary button") // .frame(maxWidth: .infinity)
                }
            )

            MoukaButton.secondary(
                disabled: state.0,
                loading: state.1,
                action: {},
                label: {
                    Text("Primary button") // .frame(maxWidth: .infinity)
                }
            )

            MoukaButton.tertiary(
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
