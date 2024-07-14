//
//  AEOTPViewRepresentable.swift
//  AEOTPTextField-SwiftUI
//
//  Created by Abdelrhman Eliwa on 31/05/2022.
//

import SwiftUI

#if os(iOS)

@available(iOS 13.0, *)
struct AEOTPViewRepresentable: UIViewRepresentable {
    @Binding private var text: String
    private let slotsCount: Int
    private let otpDefaultCharacter: String
    private let otpBackgroundColor: UIColor
    private let otpFilledBackgroundColor: UIColor
    private let otpCornerRaduis: CGFloat
    private let otpDefaultBorderColor: UIColor
    private let otpFilledBorderColor: UIColor
    private let otpDefaultBorderWidth: CGFloat
    private let otpFilledBorderWidth: CGFloat
    private let otpTextColor: UIColor
    private let otpFontSize: CGFloat
    private let otpFont: UIFont
    private let isSecureTextEntry: Bool
    private let onCommit: (() -> Void)?
    private let textField: AEOTPTextFieldSwiftUI

    init(
        text: Binding<String>,
        slotsCount: Int = 6,
        otpDefaultCharacter: String = "",
        otpBackgroundColor: UIColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1),
        otpFilledBackgroundColor: UIColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1),
        otpCornerRaduis: CGFloat = 10,
        otpDefaultBorderColor: UIColor = .clear,
        otpFilledBorderColor: UIColor = .darkGray,
        otpDefaultBorderWidth: CGFloat = 0,
        otpFilledBorderWidth: CGFloat = 1,
        otpTextColor: UIColor = .black,
        otpFontSize: CGFloat = 14,
        otpFont: UIFont = UIFont.systemFont(ofSize: 14),
        isSecureTextEntry: Bool = false,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.slotsCount = slotsCount
        self.otpDefaultCharacter = otpDefaultCharacter
        self.otpBackgroundColor = otpBackgroundColor
        self.otpFilledBackgroundColor = otpFilledBackgroundColor
        self.otpCornerRaduis = otpCornerRaduis
        self.otpDefaultBorderColor = otpDefaultBorderColor
        self.otpFilledBorderColor = otpFilledBorderColor
        self.otpDefaultBorderWidth = otpDefaultBorderWidth
        self.otpFilledBorderWidth = otpFilledBorderWidth
        self.otpTextColor = otpTextColor
        self.otpFontSize = otpFontSize
        self.otpFont = otpFont
        self.isSecureTextEntry = isSecureTextEntry
        self.onCommit = onCommit

        self.textField = AEOTPTextFieldSwiftUI(
            slotsCount: slotsCount,
            otpDefaultCharacter: otpDefaultCharacter,
            otpBackgroundColor: otpBackgroundColor,
            otpFilledBackgroundColor: otpFilledBackgroundColor,
            otpCornerRaduis: otpCornerRaduis,
            otpDefaultBorderColor: otpDefaultBorderColor,
            otpFilledBorderColor: otpFilledBorderColor,
            otpDefaultBorderWidth: otpDefaultBorderWidth,
            otpFilledBorderWidth: otpFilledBorderWidth,
            otpTextColor: otpTextColor,
            otpFontSize: otpFontSize,
            otpFont: otpFont,
            isSecureTextEntry: isSecureTextEntry
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, slotsCount: slotsCount, onCommit: onCommit)
    }

    func makeUIView(context: Context) -> AEOTPTextFieldSwiftUI {
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_: AEOTPTextFieldSwiftUI, context _: Context) {}

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding private var text: String

        private let slotsCount: Int
        private let onCommit: (() -> Void)?

        init(
            text: Binding<String>,
            slotsCount: Int,
            onCommit: (() -> Void)?
        ) {
            self._text = text
            self.slotsCount = slotsCount
            self.onCommit = onCommit

            super.init()
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""

            if textField.text?.count == slotsCount {
                onCommit?()
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
            guard let characterCount = textField.text?.count else { return false }

            // Check if the replacement string is a valid number
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)

            return allowedCharacters.isSuperset(of: characterSet)
                && characterCount < slotsCount || string.isEmpty
        }
    }
}

#elseif os(macOS)
struct AEOTPViewRepresentableMacOS: NSViewRepresentable {
    @Binding private var text: String
    private let slotsCount: Int
    private let otpDefaultCharacter: String
    private let otpBackgroundColor: NSColor
    private let otpFilledBackgroundColor: NSColor
    private let otpCornerRaduis: CGFloat
    private let otpDefaultBorderColor: NSColor
    private let otpFilledBorderColor: NSColor
    private let otpDefaultBorderWidth: CGFloat
    private let otpFilledBorderWidth: CGFloat
    private let otpTextColor: NSColor
    private let otpFontSize: CGFloat
    private let otpFont: NSFont
    private let isSecureTextEntry: Bool
    private let onCommit: (() -> Void)?
    private let textField: AEOTPTextFieldSwiftUI

    init(
        text: Binding<String>,
        slotsCount: Int = 6,
        otpDefaultCharacter: String = "",
        otpBackgroundColor: NSColor = NSColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1),
        otpFilledBackgroundColor: NSColor = NSColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1),
        otpCornerRaduis: CGFloat = 10,
        otpDefaultBorderColor: NSColor = .clear,
        otpFilledBorderColor: NSColor = .darkGray,
        otpDefaultBorderWidth: CGFloat = 0,
        otpFilledBorderWidth: CGFloat = 1,
        otpTextColor: NSColor = .black,
        otpFontSize: CGFloat = 14,
        otpFont: NSFont = NSFont.systemFont(ofSize: 14),
        isSecureTextEntry: Bool = false,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.slotsCount = slotsCount
        self.otpDefaultCharacter = otpDefaultCharacter
        self.otpBackgroundColor = otpBackgroundColor
        self.otpFilledBackgroundColor = otpFilledBackgroundColor
        self.otpCornerRaduis = otpCornerRaduis
        self.otpDefaultBorderColor = otpDefaultBorderColor
        self.otpFilledBorderColor = otpFilledBorderColor
        self.otpDefaultBorderWidth = otpDefaultBorderWidth
        self.otpFilledBorderWidth = otpFilledBorderWidth
        self.otpTextColor = otpTextColor
        self.otpFontSize = otpFontSize
        self.otpFont = otpFont
        self.isSecureTextEntry = isSecureTextEntry
        self.onCommit = onCommit

        self.textField = AEOTPTextFieldSwiftUI(
            slotsCount: slotsCount,
            otpDefaultCharacter: otpDefaultCharacter,
            otpBackgroundColor: otpBackgroundColor,
            otpFilledBackgroundColor: otpFilledBackgroundColor,
            otpCornerRaduis: otpCornerRaduis,
            otpDefaultBorderColor: otpDefaultBorderColor,
            otpFilledBorderColor: otpFilledBorderColor,
            otpDefaultBorderWidth: otpDefaultBorderWidth,
            otpFilledBorderWidth: otpFilledBorderWidth,
            otpTextColor: otpTextColor,
            otpFontSize: otpFontSize,
            otpFont: otpFont,
            isSecureTextEntry: isSecureTextEntry
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, slotsCount: slotsCount, onCommit: onCommit)
    }

    func makeNSView(context: Context) -> AEOTPTextFieldSwiftUI {
        textField.delegate = context.coordinator
        return textField
    }

    func updateNSView(_: AEOTPTextFieldSwiftUI, context _: Context) {}

    class Coordinator: NSObject, NSTextFieldDelegate {
        @Binding private var text: String

        private let slotsCount: Int
        private let onCommit: (() -> Void)?

        init(
            text: Binding<String>,
            slotsCount: Int,
            onCommit: (() -> Void)?
        ) {
            self._text = text
            self.slotsCount = slotsCount
            self.onCommit = onCommit

            super.init()
        }

        func textFieldDidChangeSelection(_ textField: NSTextField) {
            text = textField.stringValue

            if textField.stringValue.count == slotsCount {
                onCommit?()
            }
        }

        func textFieldShouldReturn(_ textField: NSTextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

//
        func textField(_ textField: NSTextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
            let characterCount = textField.stringValue.count

            // Check if the replacement string is a valid number
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)

            return allowedCharacters.isSuperset(of: characterSet)
                && characterCount < slotsCount || string.isEmpty
        }
    }
}
#endif
