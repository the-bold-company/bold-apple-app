#if os(macOS)
import AppKit

class OTPTextField: NSTextField {
    let characterLimit = 6

    private var digitLabels = [NSTextField]()
    private var labelsStackView: NSStackView!
    private var focusedField: NSTextField?

    var isError: Bool = false

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

    // MARK: - Override from parents

    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)

        if let text = stringValue as NSString? {
            if text.length > characterLimit {
                stringValue = text.substring(to: characterLimit)
            }

            for (idx, lbl) in digitLabels.enumerated() {
                if idx == stringValue.count {
                    lbl.stringValue = ""
                    focusOnLabel(lbl)
                } else if idx <= stringValue.count - 1 {
                    let stringIndex = stringValue.index(stringValue.startIndex, offsetBy: idx)
                    lbl.stringValue = String(stringValue[stringIndex])

                    if idx == stringValue.count - 1, stringValue.count == characterLimit {
                        focusOnLabel(lbl)
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
           textField !== focusedField
        {
            applyHoverBorderStyleToLabel(textField)
        }
    }

    override func mouseExited(with event: NSEvent) {
        if let userInfo = event.trackingArea?.userInfo,
           let textField = userInfo["textField"] as? NSTextField,
           textField !== focusedField
        {
            applyDefaultBorderStyleToLabel(textField)
        }
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

    @objc private func handleClick(_ sender: NSClickGestureRecognizer) {
        guard let clickedTextField = sender.view as? NSTextField else { return }

        // Reset the border of the previously focused text field
        if let previousFocusedField = focusedField {
            applyDefaultBorderStyleToLabel(previousFocusedField)
        }

        // Update the focused text field
        focusOnLabel(clickedTextField)
    }

    // MARK: - Public helpers

    func updateHighlightIfNeeded() {
        if let text = stringValue as NSString? {
            if text.length > characterLimit {
                stringValue = text.substring(to: characterLimit)
            }

            for (idx, lbl) in digitLabels.enumerated() {
                if idx == stringValue.count {
                    lbl.stringValue = ""
                    focusOnLabel(lbl)
                } else if idx <= stringValue.count - 1 {
                    let stringIndex = stringValue.index(stringValue.startIndex, offsetBy: idx)
                    lbl.stringValue = String(stringValue[stringIndex])

                    if idx == stringValue.count - 1, stringValue.count == characterLimit {
                        focusOnLabel(lbl)
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

    // MARK: - Private helpers

    private func createLabelsStackView() -> NSStackView {
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

    private func createLabel() -> NSTextField {
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

        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        label.addGestureRecognizer(clickGesture)
        return label
    }

    private func focusOnLabel(_ label: NSTextField) {
        focusedField = label

        applyHighlightStyleToLabel(label)
    }

    private func applyHighlightStyleToLabel(_ label: NSTextField) {
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

    private func applyDefaultBorderStyleToLabel(_ label: NSTextField) {
        if isError {
            applyHighlightStyleToLabel(label)
        } else {
            label.layer?.sublayers?.removeAll(where: { $0.name == "OuterBorder" })
            label.layer?.borderWidth = 1
            label.layer?.borderColor = Color(hex: 0xE5E7EB).cgColor
            label.layoutSubtreeIfNeeded()
        }
    }

    private func applyHoverBorderStyleToLabel(_ label: NSTextField) {
        if isError {
            applyHighlightStyleToLabel(label)
        } else {
            label.layer?.sublayers?.removeAll(where: { $0.name == "OuterBorder" })
            label.layer?.borderWidth = 1
            label.layer?.borderColor = NSColor.coreui.matureGreen.cgColor
            label.layoutSubtreeIfNeeded()
        }
    }
}

private class CenteredTextFieldCell: NSTextFieldCell {
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        // Get the standard text bounding rectangle
        var newRect = super.drawingRect(forBounds: rect)

        // Calculate the size of the text in the cell
        let textSize = cellSize(forBounds: rect)

        // Calculate the new rectangle by adjusting the y position to center the text vertically
        let heightDelta = newRect.size.height - textSize.height
        if heightDelta > 0 {
            newRect.origin.y += heightDelta / 2.0
        }

        return newRect
    }
}

#endif
