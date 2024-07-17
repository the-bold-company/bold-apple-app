#if os(macOS)
import AppKit
import SwiftUI

struct MoukaOTPField: View {
    @Binding private var text: String
    private let onCommit: (() -> Void)?
    private let onChange: ((String) -> Void)?
    @Binding private var error: String?
    private let autoClearErrorWhenNeeded: Bool

    init(
        text: Binding<String>,
        error: Binding<String?>,
        autoClearErrorWhenNeeded: Bool = true,
        onChange: ((String) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self._error = error
        self.autoClearErrorWhenNeeded = autoClearErrorWhenNeeded
        self.onChange = onChange
        self.onCommit = onCommit
    }

    var body: some View {
        VStack {
            OTPTextFieldRepresentable(
                text: $text,
                isError: error != nil,
                onChange: onChange,
                onCommit: onCommit
            )
            .onChange(of: text) { oldValue, newValue in
                if oldValue == newValue { return }

                guard autoClearErrorWhenNeeded else { return }
                let otpDigits = 6
                if newValue.count < otpDigits {
                    error = nil
                }
            }

            Group {
                Spacing(size: .size12)
                Text(error ?? "")
                    .typography(.bodyDefault)
                    .foregroundColor(Color(hex: 0xEF4444))
            }
            .isHidden(hidden: error == nil)
        }
        .padding()
    }
}

private typealias OTPState = (text: String, error: String?, submitted: Bool, successfulResponse: Bool)

#Preview {
    WithState(initialValue: ("", nil, false, true) as OTPState) { $state in
        VStack {
            MoukaOTPField(
                text: $state.0,
                error: $state.1,
                onChange: { _ in state.2 = false },
                onCommit: {
                    state.2 = true
                    if !state.3 {
                        state.1 = "Dãy số bạn điền không đúng. Bạn hãy kiểm tra lại nhé!"
                    }
                }
            )

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
