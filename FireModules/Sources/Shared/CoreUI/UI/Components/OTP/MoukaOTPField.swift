import AppKit
import SwiftUI

class LimitedTextField: NSTextField {
    let characterLimit = 6

    private var digitLabels = [NSTextField]()
    private var labelsStackView: NSStackView!
    private var focusedTextField: NSTextField?

    var isError: Bool = false

    private func forcusOuterBorder(_ label: NSTextField) {
        focusedTextField = label

        highlightLabel(label)
    }

    func highlightLabel(_ label: NSTextField) {
        label.layer?.borderWidth = 1
        label.layer?.borderColor = isError
            ? Color(hex: 0xEF4444).cgColor
            : NSColor.coreui.matureGreen.cgColor

        label.layer?.sublayers?.removeAll(where: { $0.name == "OuterBorder" })

        let outerBorderLayer = CALayer()
        outerBorderLayer.name = "OuterBorder"
        outerBorderLayer.borderColor = isError
            ? Color(hex: 0xEF4444).opacity(0.25).cgColor
            : Color(hex: 0x9FE870).opacity(0.5).cgColor
        outerBorderLayer.borderWidth = 4
        outerBorderLayer.cornerRadius = 10 + (4 - 1)
        outerBorderLayer.frame = label.bounds.insetBy(dx: -4, dy: -4)
        label.layer?.addSublayer(outerBorderLayer)

        label.layoutSubtreeIfNeeded()
    }

    func applyDefaultBorderStyleToLabel(_ label: NSTextField) {
        if isError {
            highlightLabel(label)
        } else {
            label.layer?.sublayers?.removeAll(where: { $0.name == "OuterBorder" })
            label.layer?.borderWidth = 1
            label.layer?.borderColor = Color(hex: 0xE5E7EB).cgColor
            label.layoutSubtreeIfNeeded()
        }
    }

    func applyHoverBorderStyleToLabel(_ label: NSTextField) {
        if isError {
            highlightLabel(label)
        } else {
            label.layer?.sublayers?.removeAll(where: { $0.name == "OuterBorder" })
            label.layer?.borderWidth = 1
            label.layer?.borderColor = NSColor.coreui.matureGreen.cgColor
            label.layoutSubtreeIfNeeded()
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        textColor = .clear
        focusRingType = .none
        isBezeled = false
        drawsBackground = true
        backgroundColor = .clear

        self.labelsStackView = createLabelsStackView()
        addSubview(labelsStackView)

        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)

//        updateHighlgheIfNeeded()

        if let text = stringValue as NSString? {
            if text.length > characterLimit {
                stringValue = text.substring(to: characterLimit)
            }

            for (idx, lbl) in digitLabels.enumerated() {
                if idx == stringValue.count {
                    lbl.stringValue = ""
                    forcusOuterBorder(lbl)
                } else if idx <= stringValue.count - 1 {
                    let stringIndex = stringValue.index(stringValue.startIndex, offsetBy: idx)
                    lbl.stringValue = String(stringValue[stringIndex])

                    if idx == stringValue.count - 1, stringValue.count == characterLimit {
                        forcusOuterBorder(lbl)
                    } else {
                        applyDefaultBorderStyleToLabel(lbl)
                    }
                } else {
                    lbl.stringValue = ""
                    applyDefaultBorderStyleToLabel(lbl)
                }
            }
        }
    }

    func updateHighlightIfNeeded() {
        if let text = stringValue as NSString? {
            if text.length > characterLimit {
                stringValue = text.substring(to: characterLimit)
            }

            for (idx, lbl) in digitLabels.enumerated() {
                if idx == stringValue.count {
                    lbl.stringValue = ""
                    forcusOuterBorder(lbl)
                } else if idx <= stringValue.count - 1 {
                    let stringIndex = stringValue.index(stringValue.startIndex, offsetBy: idx)
                    lbl.stringValue = String(stringValue[stringIndex])

                    if idx == stringValue.count - 1, stringValue.count == characterLimit {
                        forcusOuterBorder(lbl)
                    } else {
                        applyDefaultBorderStyleToLabel(lbl)
                    }
                } else {
                    lbl.stringValue = ""
                    applyDefaultBorderStyleToLabel(lbl)
                }
            }
        }
    }

    func createLabelsStackView() -> NSStackView {
        let stackView = NSStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        for _ in 1 ... 6 {
            let label = createLabel()
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        return stackView
    }

    func createLabel() -> NSTextField {
        let label = NSTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 48).isActive = true
        label.heightAnchor.constraint(equalToConstant: 62).isActive = true
        label.isEditable = false
        label.backgroundColor = .clear
        label.font = font
        label.backgroundColor = .white
        label.focusRingType = .none
        label.isBezeled = false

        label.cell = CenteredTextFieldCell(textCell: "")
        label.alignment = .center

//        textField.isBezeled = true
//        textField.drawsBackground = true
//        textField.backgroundColor = .white
//        label.textColor = otpTextColor
//        label.font = label.font?.withSize(16)
//        label.font = otpFont
        label.isEnabled = true
//        label.stringValue = otpDefaultCharacter
//        label.layer.cornerRadius = otpCornerRaduis
        label.wantsLayer = true
        label.layer?.cornerRadius = 10
//        label.layer?.masksToBounds = true

        if let cell = label.cell as? NSTextFieldCell {
            cell.alignment = .center
//               cell.ali = .center // This is a custom property we need to add
        }

        applyDefaultBorderStyleToLabel(label)
//        label.layer?.masksToBounds = true
//        forcusOuterBorder(label)

        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        label.addGestureRecognizer(clickGesture)
        return label
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        for textField in digitLabels {
            if let trackingArea = textField.trackingAreas.first {
                textField.removeTrackingArea(trackingArea)
            }
            let trackingArea = NSTrackingArea(
                rect: textField.bounds,
                options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
                owner: self,
                userInfo: ["textField": textField]
            )
            textField.addTrackingArea(trackingArea)
        }
    }

    override func mouseEntered(with event: NSEvent) {
        if let userInfo = event.trackingArea?.userInfo,
           let textField = userInfo["textField"] as? NSTextField,
           textField !== focusedTextField
        {
            applyHoverBorderStyleToLabel(textField)
        }
    }

    override func mouseExited(with event: NSEvent) {
        if let userInfo = event.trackingArea?.userInfo,
           let textField = userInfo["textField"] as? NSTextField,
           textField !== focusedTextField
        {
            applyDefaultBorderStyleToLabel(textField)
        }
    }

    @objc private func handleClick(_ sender: NSClickGestureRecognizer) {
        guard let clickedTextField = sender.view as? NSTextField else { return }

        // Reset the border of the previously focused text field
        if let previousFocusedTextField = focusedTextField {
            applyDefaultBorderStyleToLabel(previousFocusedTextField)
        }

        // Update the focused text field
        forcusOuterBorder(clickedTextField)
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        for textField in digitLabels {
            let localPoint = convert(point, to: textField)
            if textField.bounds.contains(localPoint) {
                return textField
            }
        }
        return nil
    }

    override func becomeFirstResponder() -> Bool {
        let textView = window?.fieldEditor(true, for: nil) as? NSTextView
        textView?.insertionPointColor = .clear

        let result = super.becomeFirstResponder()

        // Disable text selection
        if result {
            if let editor = window?.fieldEditor(true, for: self) as? NSTextView {
                editor.selectedRange = NSRange(location: editor.string.count, length: 0)
            }
        }
        return result
    }

    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}

struct LimitedTextFieldRepresentable: NSViewRepresentable {
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

    func makeNSView(context: Context) -> LimitedTextField {
        let textField = LimitedTextField()
        textField.delegate = context.coordinator
        textField.stringValue = text
        textField.isError = isError
        textField.updateHighlightIfNeeded()
        return textField
    }

    func updateNSView(_ nsView: LimitedTextField, context _: Context) {
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

struct MoukaOTPField: View {
    @Binding private var text: String
    private let onCommit: (() -> Void)?
    private let onChange: ((String) -> Void)?
    let error: String?

    init(text: Binding<String>, error: String? = nil, onChange: ((String) -> Void)? = nil, onCommit: (() -> Void)? = nil) {
        self._text = text
        self.error = error
        self.onChange = onChange
        self.onCommit = onCommit
    }

    var body: some View {
        VStack {
            LimitedTextFieldRepresentable(
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
        .padding()
    }
}

typealias OTPState = (text: String, error: String?, submited: Bool)

#Preview {
    WithState(initialValue: ("", nil, false) as OTPState) { $state in
        VStack {
            MoukaOTPField(
                text: $state.0,
                onChange: { _ in state.2 = false },
                onCommit: { state.2 = true }
            )

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

#Preview {
    WithState(initialValue: ("", nil, false) as OTPState) { $state in
        VStack {
            MoukaOTPField(
                text: $state.0,
                error: state.1,
                onCommit: {
                    state.1 = "Dãy số bạn điền không đúng. Bạn hãy kiểm tra lại nhé!"
                }
            )

            Button(action: { state.1 = nil }, label: {
                Text("Clear error")
            })

            Text("You typed: \(state.0)")
        }
        .padding()
        .background(Color.white)
    }
    .preferredColorScheme(.light)
}
