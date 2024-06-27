//
//  AEOTPTextField.swift
//  AEOTPTextField
//
//  Created by Abdelrhman Eliwa on 10/12/20.
//  Copyright © 2020 Abdelrhman Eliwa. All rights reserved.
//
#if os(iOS)
    import UIKit

    public class AEOTPTextField: UITextField {
        // MARK: - PROPERTIES

        //
        /// The default character placed in the text field slots
        public var otpDefaultCharacter = ""
        /// The default background color of the text field slots before entering a character
        public var otpBackgroundColor: UIColor = .clear
        /// The default background color of the text field slots after entering a character
        public var otpFilledBackgroundColor: UIColor = .clear
        /// The default corner raduis of the text field slots
        public var otpCornerRaduis: CGFloat = 8
        /// The default border color of the text field slots before entering a character
        public var otpDefaultBorderColor: UIColor = .lightGray
        /// The border color of the text field slots after entering a character
        public var otpFilledBorderColor: UIColor = .coreui.forestGreen
        /// The default border width of the text field slots before entering a character
        public var otpDefaultBorderWidth: CGFloat = 1
        /// The border width of the text field slots after entering a character
        public var otpFilledBorderWidth: CGFloat = 4
        /// The default text color of the text
        public var otpTextColor: UIColor = .black
        /// The default font size of the text
        public var otpFontSize: CGFloat = 16
        /// The default font of the text
        public var otpFont: UIFont = .systemFont(ofSize: 16)
        /// The delegate of the AEOTPTextFieldDelegate protocol
        public weak var otpDelegate: AEOTPTextFieldDelegate?

        private var implementation = AEOTPTextFieldImplementation()
        private var isConfigured = false
        private var digitLabels = [UILabel]()
        private lazy var tapRecognizer: UITapGestureRecognizer = {
            let recognizer = UITapGestureRecognizer()
            recognizer.addTarget(self, action: #selector(becomeFirstResponder))
            return recognizer
        }()

        // MARK: - METHODS

        //
        /// This func is used to configure the `AEOTPTextField`, Usually you need to call this method into `viewDidLoad()`
        /// - Parameter slotCount: the number of OTP slots in the TextField
        public func configure(with slotCount: Int = 6) {
            guard isConfigured == false else { return }
            isConfigured.toggle()
            configureTextField()

            let labelsStackView = createLabelsStackView(with: slotCount)
            addSubview(labelsStackView)
            labelsStackView.addGestureRecognizer(tapRecognizer)
//        addGestureRecognizer(tapRecognizer)
            NSLayoutConstraint.activate([
                labelsStackView.topAnchor.constraint(equalTo: topAnchor),
                labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }

        /// Use this func if you need to clear the `OTP` text and reset the `AEOTPTextField` to the default state
        public func clearOTP() {
            text = nil
            digitLabels.forEach { currentLabel in
                currentLabel.text = otpDefaultCharacter
                currentLabel.layer.borderWidth = otpDefaultBorderWidth
                currentLabel.layer.borderColor = otpDefaultBorderColor.cgColor
                currentLabel.backgroundColor = otpBackgroundColor
            }
        }

        /// Use this func to set the text in the code
        public func setText(_ text: String) {
            let characters = Array(text)
            for i in 0 ..< characters.count {
                if digitLabels.indices.contains(i) {
                    digitLabels[i].text = String(characters[i])
                }
            }
        }

        override public func canPerformAction(_: Selector, withSender _: Any?) -> Bool {
            // Disable the tooltips (aka the edit menu) that appear when tapping on a UITextField.
            return false
        }

        override public func caretRect(for _: UITextPosition) -> CGRect {
            // Hide the cursor completely by making its rectangle zero-sized.
            return .zero
        }

        override public func selectionRects(for _: UITextRange) -> [UITextSelectionRect] {
            // Prevent the text selection handles from appearing.
            return []
        }
    }

    // MARK: - PRIVATE METHODS

//
    private extension AEOTPTextField {
        func configureTextField() {
            tintColor = .clear
            textColor = .clear
            keyboardType = .numberPad
            textContentType = .oneTimeCode
            autocorrectionType = .no
            borderStyle = .none
            addTarget(self, action: #selector(textDidChange), for: .editingChanged)
//        isUserInteractionEnabled = false
            delegate = implementation
            implementation.implementationDelegate = self
            // TODO: DIsable copy and paste for TextField
        }

        func createLabelsStackView(with count: Int) -> UIStackView {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            for _ in 1 ... count {
                let label = createLabel()
                stackView.addArrangedSubview(label)
                digitLabels.append(label)
            }
            return stackView
        }

        func createLabel() -> UILabel {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.textColor = otpTextColor
            label.font = label.font.withSize(otpFontSize)
            label.font = otpFont
            label.isUserInteractionEnabled = true
            label.text = otpDefaultCharacter
            label.layer.cornerRadius = otpCornerRaduis
            // label.layer.masksToBounds = true
            applyDefaultBorderStyleToLabel(label)
            return label
        }

        @objc
        func textDidChange() {
            guard let text, text.count <= digitLabels.count else { return }
            for labelIndex in 0 ..< digitLabels.count {
                let currentLabel = digitLabels[labelIndex]
                currentLabel.layer.sublayers?.removeAll(where: { $0.name == "OuterBorder" })

                if labelIndex == text.count - 1 {
                    let index = text.index(text.startIndex, offsetBy: labelIndex)
                    currentLabel.text = isSecureTextEntry ? "✱" : String(text[index])

                    applyHighlightBorderStyleToLabel(currentLabel)
                } else if labelIndex < text.count - 1 {
                    let index = text.index(text.startIndex, offsetBy: labelIndex)
                    currentLabel.text = isSecureTextEntry ? "✱" : String(text[index])
                    applyDefaultBorderStyleToLabel(currentLabel)
                } else {
                    currentLabel.text = otpDefaultCharacter
                    applyDefaultBorderStyleToLabel(currentLabel)
                }
            }

            if text.count == digitLabels.count {
                otpDelegate?.didUserFinishEnter(the: text)
            }
        }

        func applyHighlightBorderStyleToLabel(_ label: UILabel) {
            label.backgroundColor = otpFilledBackgroundColor
            label.layer.borderWidth = otpDefaultBorderWidth
            label.layer.borderColor = otpFilledBorderColor.cgColor

            let outerBorderLayer = CALayer()
            outerBorderLayer.name = "OuterBorder"
            outerBorderLayer.borderColor = UIColor(red: 0.62, green: 0.91, blue: 0.44, alpha: 0.99).cgColor
            outerBorderLayer.borderWidth = otpFilledBorderWidth
            outerBorderLayer.frame = label.bounds.insetBy(dx: -otpFilledBorderWidth, dy: -otpFilledBorderWidth)
            outerBorderLayer.cornerRadius = otpCornerRaduis + (otpFilledBorderWidth - otpDefaultBorderWidth)
            outerBorderLayer.masksToBounds = true
            label.layer.addSublayer(outerBorderLayer)
        }

        func applyDefaultBorderStyleToLabel(_ label: UILabel) {
            label.backgroundColor = otpBackgroundColor
            label.layer.borderWidth = otpDefaultBorderWidth
            label.layer.borderColor = otpDefaultBorderColor.cgColor
        }
    }

    // MARK: - AEOTPTextFieldImplementationProtocol Delegate

//
    extension AEOTPTextField: AEOTPTextFieldImplementationProtocol {
        var digitalLabelsCount: Int {
            digitLabels.count
        }
    }
#endif
