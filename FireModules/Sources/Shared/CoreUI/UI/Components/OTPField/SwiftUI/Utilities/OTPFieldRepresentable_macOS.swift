#if os(macOS)
import AppKit
import SwiftUI

struct OTPTextFieldRepresentable: NSViewRepresentable {
    @Binding private var text: String
    private let onCommit: (() -> Void)?
    private let onChange: ((String) -> Void)?
    private var isError: Bool

    init(text: Binding<String>, isError: Bool = false, onChange: ((String) -> Void)? = nil, onCommit: (() -> Void)? = nil) {
        self._text = text
        self.isError = isError
        self.onChange = onChange
        self.onCommit = onCommit
    }

    func makeNSView(context: Context) -> OTPTextField {
        let textField = OTPTextField()
        textField.delegate = context.coordinator
        textField.stringValue = text
        textField.isError = isError
        textField.updateHighlightIfNeeded()
        return textField
    }

    func updateNSView(_ nsView: OTPTextField, context _: Context) {
        nsView.stringValue = text
        nsView.isError = isError
        nsView.updateHighlightIfNeeded()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, onChange: onChange, onCommit: onCommit)
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        @Binding private var text: String
        private let onChange: ((String) -> Void)?
        private let onCommit: (() -> Void)?

        init(text: Binding<String>, onChange: ((String) -> Void)? = nil, onCommit: (() -> Void)? = nil) {
            self._text = text
            self.onChange = onChange
            self.onCommit = onCommit
        }

        func control(_: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
            text = fieldEditor.string
            return true
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                onChange?(textField.stringValue)

                let stringValue = textField.stringValue as NSString
                if stringValue.length > 6 {
                    text = stringValue.substring(to: 6)
                } else {
                    text = String(stringValue)
                }

                if stringValue.length == 6 {
                    onCommit?()
                }
            }
        }
    }
}
#endif
