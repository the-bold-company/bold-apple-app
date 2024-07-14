#if os(macOS)
import AppKit

public class AEOTPTextField: NSTextField {
    // MARK: - PROPERTIES

    //
    /// The default character placed in the text field slots
    public var otpDefaultCharacter = ""
    /// The default background color of the text field slots before entering a character
    public var otpBackgroundColor: NSColor = .clear
    /// The default background color of the text field slots after entering a character
    public var otpFilledBackgroundColor: NSColor = .clear
    /// The default corner raduis of the text field slots
    public var otpCornerRaduis: CGFloat = 8
    /// The default border color of the text field slots before entering a character
    public var otpDefaultBorderColor: NSColor = .lightGray
    /// The border color of the text field slots after entering a character
    public var otpFilledBorderColor: NSColor = .coreui.forestGreen
    /// The default border width of the text field slots before entering a character
    public var otpDefaultBorderWidth: CGFloat = 1
    /// The border width of the text field slots after entering a character
    public var otpFilledBorderWidth: CGFloat = 4
    /// The default text color of the text
    public var otpTextColor: NSColor = .black
    /// The default font size of the text
//    public var otpFontSize: CGFloat = 16
    /// The default font of the text
    public var otpFont: NSFont = .systemFont(ofSize: 16)
    /// The delegate of the AEOTPTextFieldDelegate protocol
    public weak var otpDelegate: AEOTPTextFieldDelegate?

    private var implementation = AEOTPTextFieldImplementation()
    private var isConfigured = false
    private var digitLabels = [NSTextField]()
    private lazy var tapRecognizer: NSClickGestureRecognizer = {
        let recognizer = NSClickGestureRecognizer()
        recognizer.target = self
        recognizer.action = #selector(becomeFirstResponder)
//        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()

    // MARK: - METHODS

    //
    /// This func is used to configure the `AEOTPTextField`, Usually you need to call this method into `viewDidLoad()`
    /// - Parameter slotCount: the number of OTP slots in the TextField
    public func configure(with _: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        configureTextField()

//        let labelsStackView = createLabelsStackView(with: slotCount)
//        addSubview(labelsStackView)
//        labelsStackView.addGestureRecognizer(tapRecognizer)
        ////        addGestureRecognizer(tapRecognizer)
//        NSLayoutConstraint.activate([
//            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
//            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
    }

    /// Use this func if you need to clear the `OTP` text and reset the `AEOTPTextField` to the default state
    public func clearOTP() {
        stringValue = "" // nil
        digitLabels.forEach { currentLabel in
            currentLabel.stringValue = otpDefaultCharacter
            currentLabel.layer?.borderWidth = otpDefaultBorderWidth
            currentLabel.layer?.borderColor = otpDefaultBorderColor.cgColor
            currentLabel.backgroundColor = otpBackgroundColor
        }
    }

    /// Use this func to set the text in the code
    public func setText(_ text: String) {
        let characters = Array(text)
        for i in 0 ..< characters.count {
            if digitLabels.indices.contains(i) {
                digitLabels[i].stringValue = String(characters[i])
            }
        }
    }

    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(self, name: NSText.didChangeNotification, object: self)
    }

//    override public func canPerformAction(_: Selector, withSender _: Any?) -> Bool {
//        // Disable the tooltips (aka the edit menu) that appear when tapping on a UITextField.
//        return false
//    }

//    override public func caretRect(for _: UITextPosition) -> CGRect {
//        // Hide the cursor completely by making its rectangle zero-sized.
//        return .zero
//    }

//    override public func selectionRects(for _: NSTextRange) -> [NSTextSelectionRect] {
//        // Prevent the text selection handles from appearing.
//        return []
//    }
}

// MARK: - PRIVATE METHODS

//
private extension AEOTPTextField {
    func configureTextField() {
//        tintColor = .clear
        textColor = .blue

//        keyboardType = .numberPad
        let f = NumberFormatter()
//        f.numberStyle = .
        formatter = f

//        textContentType = .oneTimeCode
//        autocorrectionType = .no

//        borderStyle = .none
        focusRingType = .none
//        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSText.didChangeNotification, object: self)
//        isUserInteractionEnabled = false
        delegate = implementation
        implementation.implementationDelegate = self
        // TODO: DIsable copy and paste for TextField
    }

    func createLabelsStackView(with count: Int) -> NSStackView {
        let stackView = NSStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.layer?.borderWidth = 2
        stackView.layer?.borderColor = NSColor.blue.cgColor
        for _ in 1 ... count {
            let label = createLabel()
            stackView.addArrangedSubview(label)
            NSLayoutConstraint.activate([
                //                label.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CGFloat(1) / CGFloat(6)),
                label.widthAnchor.constraint(equalToConstant: (frame.width - 16 * 5) / 6),
                label.heightAnchor.constraint(equalToConstant: 62),

            ])
            digitLabels.append(label)
        }
        return stackView
    }

    func createLabel() -> NSTextField {
        let label = NSTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        let centeredCell = CenteredTextFieldCell(textCell: "")
        label.cell = centeredCell
        label.alignment = .center

//        textField.isBezeled = true
//        textField.drawsBackground = true
//        textField.backgroundColor = .white
        label.textColor = otpTextColor
        label.font = label.font?.withSize(16)
        label.font = otpFont
        label.isEnabled = true
        label.stringValue = otpDefaultCharacter
//        label.layer.cornerRadius = otpCornerRaduis
        label.wantsLayer = true
        label.layer?.cornerRadius = 10
        // label.layer.masksToBounds = true

        applyDefaultBorderStyleToLabel(label)
        return label
    }

    @objc
    func textDidChange() {
//        guard stringValue.count <= digitLabels.count else { return }
        for labelIndex in 0 ..< digitLabels.count {
            var currentLabel = digitLabels[labelIndex]
            currentLabel.layer?.sublayers?.removeAll(where: { $0.name == "OuterBorder" })

            if labelIndex == stringValue.count - 1 {
                let index = stringValue.index(stringValue.startIndex, offsetBy: labelIndex)
//                currentLabel.text = isSecureTextEntry ? "✱" : String(stringValue[index])
                currentLabel.stringValue = String(stringValue[index])

                applyHighlightBorderStyleToLabel(currentLabel)
            } else if labelIndex < stringValue.count - 1 {
                let index = stringValue.index(stringValue.startIndex, offsetBy: labelIndex)
//                currentLabel.text = isSecureTextEntry ? "✱" : String(text[index])
                currentLabel.stringValue = String(stringValue[index])
                applyDefaultBorderStyleToLabel(currentLabel)
            } else {
                currentLabel.stringValue = otpDefaultCharacter
                applyDefaultBorderStyleToLabel(currentLabel)
            }
        }

        if stringValue.count == digitLabels.count {
            otpDelegate?.didUserFinishEnter(the: stringValue)
        }
    }

    func applyHighlightBorderStyleToLabel(_ label: NSTextField) {
        label.backgroundColor = otpFilledBackgroundColor
        label.layer?.borderWidth = otpDefaultBorderWidth
        label.layer?.borderColor = otpFilledBorderColor.cgColor

        let outerBorderLayer = CALayer()
        outerBorderLayer.name = "OuterBorder"
        outerBorderLayer.borderColor = NSColor(red: 0.62, green: 0.91, blue: 0.44, alpha: 0.99).cgColor
        outerBorderLayer.borderWidth = otpFilledBorderWidth
        outerBorderLayer.frame = label.bounds.insetBy(dx: -otpFilledBorderWidth, dy: -otpFilledBorderWidth)
        outerBorderLayer.cornerRadius = otpCornerRaduis + (otpFilledBorderWidth - otpDefaultBorderWidth)
        outerBorderLayer.masksToBounds = true
        label.layer?.addSublayer(outerBorderLayer)
    }

    func applyDefaultBorderStyleToLabel(_ label: NSTextField) {
        label.backgroundColor = otpBackgroundColor
        label.layer?.borderWidth = otpDefaultBorderWidth
        label.layer?.borderColor = otpDefaultBorderColor.cgColor
    }
}

// MARK: - AEOTPTextFieldImplementationProtocol Delegate

//
extension AEOTPTextField: AEOTPTextFieldImplementationProtocol {
    var digitalLabelsCount: Int {
        digitLabels.count
    }
}

class CenteredTextFieldCell: NSTextFieldCell {
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

class AEOTPTextFieldImplementation: NSObject, NSTextFieldDelegate {
    weak var implementationDelegate: AEOTPTextFieldImplementationProtocol?

    func textField(
        _ textField: NSTextField,
        shouldChangeCharactersIn _: NSRange,
        replacementString string: String
    ) -> Bool {
        let characterCount = textField.stringValue.count
//
//        // Check if the replacement string is a valid number
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
//
        return allowedCharacters.isSuperset(of: characterSet)
            && characterCount < implementationDelegate?.digitalLabelsCount ?? 0 || string == ""
    }

//    func controlTextDidChange(_ obj: Notification) {
//        if let textField = obj.object as? NSTextField {
//            parent.text = textField.stringValue
//        }
//    }
//
//    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
//        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
//        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
//        return predicate.evaluate(with: fieldEditor.string)
//    }
}
#endif
