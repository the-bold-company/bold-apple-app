#if os(macOS)
import AppKit
import SwiftUI

public struct MoukaOTPField: View {
    @Binding private var text: String
    private let onCommit: (() -> Void)?
    private let onChange: ((String) -> Void)?
    private let error: String?

    public init(
        text: Binding<String>,
        error: String?,
        onChange: ((String) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.error = error
        self.onChange = onChange
        self.onCommit = onCommit
    }

    public var body: some View {
        VStack {
            OTPTextFieldRepresentable(
                text: $text,
                isError: error != nil,
                onChange: onChange,
                onCommit: onCommit
            )

            Group {
                Spacing(size: .size12)
                Text(error ?? "")
                    .typography(.bodyDefault)
                    .foregroundColor(Color(hex: 0xEF4444))
            }
            .isHidden(hidden: error == nil)
        }
        .frame(minHeight: 62)
    }
}

private typealias OTPState = (text: String, error: String?, submitted: Bool, successfulResponse: Bool)

#Preview {
    WithState(initialValue: ("", nil, false, true) as OTPState) { $state in
        VStack {
            MoukaOTPField(
                text: $state.0,
                error: state.1,
                onChange: { _ in state.2 = false },
                onCommit: {
                    state.2 = true
                    if !state.3 {
                        state.1 = "Dãy số bạn điền không đúng. Bạn hãy kiểm tra lại nhé!"
                    }
                }
            )
            .onChange(of: state.0) { oldValue, newValue in
                if oldValue == newValue { return }

                let otpDigits = 6
                if oldValue.count == otpDigits, newValue.count == otpDigits - 1 {
                    state.1 = nil
                }
            }

            Toggle("Successful response?", isOn: $state.3)

            Text(state.2
                ? "OTP \(state.0) has been submitted"
                : "You typed: \(state.0)"
            )
        }
        .padding()
        .background(Color.white)
    }
    .preferredColorScheme(.light)
}
#endif
