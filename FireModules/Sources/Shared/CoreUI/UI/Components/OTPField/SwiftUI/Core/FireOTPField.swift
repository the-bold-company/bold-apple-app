//
//  FireOTPField.swift
//  AEOTPTextField-SwiftUI
//
//  Created by Abdelrhman Eliwa on 01/06/2022.
//
import Combine
import SwiftUI
#if os(iOS)

@available(iOS 13.0, *)
/// OTP field, inspired by `AEOTPTextField` package (https://github.com/AbdelrhmanKamalEliwa/AEOTPTextField)
public struct FireOTPField: View {
    // MARK: - PROPERTIES

    //
    /// A Boolean value that used to help the `FireOTPField` supporting Clear OTP
    @State private var flag: Bool = false
    /// A Binding String value of the OTP
    @Binding private var text: String
    /// An Intger value to set the number of the slots of the `FireOTPField`
    private let slotsCount: Int
    /// A CGFloat value to set a custom width to the `FireOTPField`
    private let width: CGFloat
    /// A CGFloat value to set a custom height to the `FireOTPField`
    private let height: CGFloat
    /// The default character placed in the text field slots
    private let otpDefaultCharacter: String
    /// The default background color of the text field slots before entering a character
    private let otpBackgroundColor: UIColor
    /// The default background color of the text field slots after entering a character
    private let otpFilledBackgroundColor: UIColor
    /// The default corner raduis of the text field slots
    private let otpCornerRaduis: CGFloat
    /// The default border color of the text field slots before entering a character
    private let otpDefaultBorderColor: UIColor
    /// The border color of the text field slots after entering a character
    private let otpFilledBorderColor: UIColor
    /// The default border width of the text field slots before entering a character
    private let otpDefaultBorderWidth: CGFloat
    /// The border width of the text field slots after entering a character
    private let otpFilledBorderWidth: CGFloat
    /// The default text color of the text
    private let otpTextColor: UIColor
    /// The default font size of the text
    private let otpFontSize: CGFloat
    /// The default font of the text
    private let otpFont: UIFont
    /// A Boolean value that indicates whether the text object disables text copying and, in some cases, hides the text that the user enters.
    private let isSecureTextEntry: Bool
    /// A Boolean value that used to allow the `FireOTPField` clear the OTP and set the `FireOTPField` to the default state when you set the OTP Text with Empty Value
    private let enableClearOTP: Bool
    /// A Closure that fires when the OTP returned
    private var onCommit: (() -> Void)?

    // MARK: - INIT

    //
    /// The Initializer of the `AEOTPTextView`
    /// - Parameters:
    ///   - text: The OTP text that entered into FireOTPField
    ///   - slotsCount: The number of OTP slots in the FireOTPField
    ///   - width: The default width of the FireOTPField
    ///   - height: The default height of the FireOTPField
    ///   - otpDefaultCharacter: The default character placed in the text field slots
    ///   - otpBackgroundColor: The default background color of the text field slots before entering a character
    ///   - otpFilledBackgroundColor: The default background color of the text field slots after entering a character
    ///   - otpCornerRaduis: The default corner raduis of the text field slots
    ///   - otpDefaultBorderColor: The default border color of the text field slots before entering a character
    ///   - otpFilledBorderColor: The border color of the text field slots after entering a character
    ///   - otpDefaultBorderWidth: The default border width of the text field slots before entering a character
    ///   - otpFilledBorderWidth: The border width of the text field slots after entering a character
    ///   - otpTextColor: The default text color of the text
    ///   - otpFontSize: The default font size of the text
    ///   - otpFont: The default font of the text
    ///   - isSecureTextEntry: A Boolean value that indicates whether the text object disables text copying and, in some cases, hides the text that the user enters.
    ///   - enableClearOTP: A Boolean value that used to allow the `FireOTPField` clear the OTP and set the `FireOTPField` to the default state when you set the OTP Text with Empty Value
    ///   - onCommit: A Closure that fires when the OTP returned
    public init(
        text: Binding<String>,
        slotsCount: Int = 6,
        width: CGFloat = UIScreen.main.bounds.width * 0.8,
        height: CGFloat = 62,
        otpDefaultCharacter: String = "",
        otpBackgroundColor: UIColor = .clear,
        otpFilledBackgroundColor: UIColor = .clear,
        otpCornerRaduis: CGFloat = 8,
        otpDefaultBorderColor: UIColor = .lightGray,
        otpFilledBorderColor: UIColor = .coreui.forestGreen,
        otpDefaultBorderWidth: CGFloat = 1,
        otpFilledBorderWidth: CGFloat = 4,
        otpTextColor: UIColor = .black,
        otpFontSize: CGFloat = 16,
        otpFont: UIFont = UIFont.systemFont(ofSize: 16),
        isSecureTextEntry: Bool = false,
        enableClearOTP: Bool = false,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.slotsCount = slotsCount
        self.width = width
        self.height = height
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
        self.enableClearOTP = enableClearOTP
        self.onCommit = onCommit
    }

    // MARK: - BODY

    //
    public var body: some View {
        ZStack {
            if flag {
                otpView
            } else {
                otpView
            }
        } //: ZStack
        .frame(width: width, height: height)
        .onChange(of: text) { newValue in
            guard enableClearOTP else { return }
            if newValue.isEmpty {
                flag.toggle()
            } //: condition
        } //: onChange
    } //: body

    // MARK: - VIEWS

    //
    var otpView: some View {
        AEOTPViewRepresentable(
            text: $text,
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
            isSecureTextEntry: isSecureTextEntry,
            onCommit: onCommit
        )
    } //: otpView
}

#elseif os(macOS)
/// OTP field, inspired by `AEOTPTextField` package (https://github.com/AbdelrhmanKamalEliwa/AEOTPTextField)
// public struct MoukaOTPField: View {
//    // MARK: - PROPERTIES
//
//    //
//    /// A Boolean value that used to help the `FireOTPField` supporting Clear OTP
//    @State private var flag: Bool = false
//    /// A Binding String value of the OTP
//    @Binding private var text: String
//    /// An Intger value to set the number of the slots of the `FireOTPField`
//    private let slotsCount: Int
//    /// A CGFloat value to set a custom width to the `FireOTPField`
//    private let width: CGFloat
//    /// A CGFloat value to set a custom height to the `FireOTPField`
//    private let height: CGFloat
//    /// The default character placed in the text field slots
//    private let otpDefaultCharacter: String
//    /// The default background color of the text field slots before entering a character
//    private let otpBackgroundColor: NSColor
//    /// The default background color of the text field slots after entering a character
//    private let otpFilledBackgroundColor: NSColor
//    /// The default corner raduis of the text field slots
//    private let otpCornerRaduis: CGFloat
//    /// The default border color of the text field slots before entering a character
//    private let otpDefaultBorderColor: NSColor
//    /// The border color of the text field slots after entering a character
//    private let otpFilledBorderColor: NSColor
//    /// The default border width of the text field slots before entering a character
//    private let otpDefaultBorderWidth: CGFloat
//    /// The border width of the text field slots after entering a character
//    private let otpFilledBorderWidth: CGFloat
//    /// The default text color of the text
//    private let otpTextColor: NSColor
//    /// The default font size of the text
//    private let otpFontSize: CGFloat
//    /// The default font of the text
//    private let otpFont: NSFont
//    /// A Boolean value that indicates whether the text object disables text copying and, in some cases, hides the text that the user enters.
//    private let isSecureTextEntry: Bool
//    /// A Boolean value that used to allow the `FireOTPField` clear the OTP and set the `FireOTPField` to the default state when you set the OTP Text with Empty Value
//    private let enableClearOTP: Bool
//    /// A Closure that fires when the OTP returned
//    private var onCommit: (() -> Void)?
//
//    // MARK: - INIT
//
//    //
//    /// The Initializer of the `AEOTPTextView`
//    /// - Parameters:
//    ///   - text: The OTP text that entered into FireOTPField
//    ///   - slotsCount: The number of OTP slots in the FireOTPField
//    ///   - width: The default width of the FireOTPField
//    ///   - height: The default height of the FireOTPField
//    ///   - otpDefaultCharacter: The default character placed in the text field slots
//    ///   - otpBackgroundColor: The default background color of the text field slots before entering a character
//    ///   - otpFilledBackgroundColor: The default background color of the text field slots after entering a character
//    ///   - otpCornerRaduis: The default corner raduis of the text field slots
//    ///   - otpDefaultBorderColor: The default border color of the text field slots before entering a character
//    ///   - otpFilledBorderColor: The border color of the text field slots after entering a character
//    ///   - otpDefaultBorderWidth: The default border width of the text field slots before entering a character
//    ///   - otpFilledBorderWidth: The border width of the text field slots after entering a character
//    ///   - otpTextColor: The default text color of the text
//    ///   - otpFontSize: The default font size of the text
//    ///   - otpFont: The default font of the text
//    ///   - isSecureTextEntry: A Boolean value that indicates whether the text object disables text copying and, in some cases, hides the text that the user enters.
//    ///   - enableClearOTP: A Boolean value that used to allow the `FireOTPField` clear the OTP and set the `FireOTPField` to the default state when you set the OTP Text with Empty Value
//    ///   - onCommit: A Closure that fires when the OTP returned
//    public init(
//        text: Binding<String>,
//        slotsCount: Int = 6,
//        width: CGFloat = NSScreen.main!.frame.width * 0.8,
//        height: CGFloat = 62,
//        otpDefaultCharacter: String = "",
//        otpBackgroundColor: NSColor = .clear,
//        otpFilledBackgroundColor: NSColor = .clear,
//        otpCornerRaduis: CGFloat = 8,
//        otpDefaultBorderColor: NSColor = .lightGray,
//        otpFilledBorderColor: NSColor = .coreui.forestGreen,
//        otpDefaultBorderWidth: CGFloat = 1,
//        otpFilledBorderWidth: CGFloat = 4,
//        otpTextColor: NSColor = .black,
//        otpFontSize: CGFloat = 16,
//        otpFont: NSFont = NSFont.systemFont(ofSize: 16),
//        isSecureTextEntry: Bool = false,
//        enableClearOTP: Bool = false,
//        onCommit: (() -> Void)? = nil
//    ) {
//        self._text = text
//        self.slotsCount = slotsCount
//        self.width = width
//        self.height = height
//        self.otpDefaultCharacter = otpDefaultCharacter
//        self.otpBackgroundColor = otpBackgroundColor
//        self.otpFilledBackgroundColor = otpFilledBackgroundColor
//        self.otpCornerRaduis = otpCornerRaduis
//        self.otpDefaultBorderColor = otpDefaultBorderColor
//        self.otpFilledBorderColor = otpFilledBorderColor
//        self.otpDefaultBorderWidth = otpDefaultBorderWidth
//        self.otpFilledBorderWidth = otpFilledBorderWidth
//        self.otpTextColor = otpTextColor
//        self.otpFontSize = otpFontSize
//        self.otpFont = otpFont
//        self.isSecureTextEntry = isSecureTextEntry
//        self.enableClearOTP = enableClearOTP
//        self.onCommit = onCommit
//    }
//
//    // MARK: - BODY
//
//    //
//    public var body: some View {
//        ZStack {
//            if flag {
//                otpView
//            } else {
//                otpView
//            }
//        } //: ZStack
//        .frame(width: width, height: height)
//        .onChange(of: text) { newValue in
//            guard enableClearOTP else { return }
//            if newValue.isEmpty {
//                flag.toggle()
//            } //: condition
//        } //: onChange
//    } //: body
//
//    // MARK: - VIEWS
//
//    //
//    var otpView: some View {
//        AEOTPViewRepresentableMacOS(
//            text: $text,
//            slotsCount: slotsCount,
//            otpDefaultCharacter: otpDefaultCharacter,
//            otpBackgroundColor: otpBackgroundColor,
//            otpFilledBackgroundColor: otpFilledBackgroundColor,
//            otpCornerRaduis: otpCornerRaduis,
//            otpDefaultBorderColor: otpDefaultBorderColor,
//            otpFilledBorderColor: otpFilledBorderColor,
//            otpDefaultBorderWidth: otpDefaultBorderWidth,
//            otpFilledBorderWidth: otpFilledBorderWidth,
//            otpTextColor: otpTextColor,
//            otpFontSize: otpFontSize,
//            otpFont: otpFont,
//            isSecureTextEntry: isSecureTextEntry,
//            onCommit: onCommit
//        )
//    } //: otpView
// }

#endif
// #Preview {
//    WithState(initialValue: "hehe") { $text2 in
//        WithState(initialValue: "") { $text in
//            MoukaOTPField(text: $text, slotsCount: 6) {
////                print("Submit")
//
//                text2 = "Submit oi nha"
//            }
//            //            .frame(width: 360)
//            //        FireOTPField(text: $text, slotsCount: 6)
//            Text(text)
//            Text(text2)
//        }
//    }
//    .padding()
//    .preferredColorScheme(.light)
// }
