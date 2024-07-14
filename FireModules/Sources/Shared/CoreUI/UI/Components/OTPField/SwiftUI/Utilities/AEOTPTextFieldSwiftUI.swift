//
//  AEOTPTextFieldSwiftUI.swift
//  AEOTPTextField-SwiftUI
//
//  Created by Abdelrhman Eliwa on 01/06/2022.
//

#if os(iOS)
import UIKit

@available(iOS 13.0, *)
class AEOTPTextFieldSwiftUI: AEOTPTextField {
    init(
        slotsCount: Int,
        otpDefaultCharacter: String,
        otpBackgroundColor: UIColor,
        otpFilledBackgroundColor: UIColor,
        otpCornerRaduis: CGFloat,
        otpDefaultBorderColor: UIColor,
        otpFilledBorderColor: UIColor,
        otpDefaultBorderWidth: CGFloat,
        otpFilledBorderWidth: CGFloat,
        otpTextColor: UIColor,
        otpFontSize: CGFloat,
        otpFont: UIFont,
        isSecureTextEntry: Bool
    ) {
        super.init(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width * 0.8, height: 40)))

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

        configure(with: slotsCount)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#elseif os(macOS)
import AppKit

class AEOTPTextFieldSwiftUI: AEOTPTextField {
    init(
        slotsCount: Int,
        otpDefaultCharacter: String,
        otpBackgroundColor: NSColor,
        otpFilledBackgroundColor: NSColor,
        otpCornerRaduis: CGFloat,
        otpDefaultBorderColor: NSColor,
        otpFilledBorderColor: NSColor,
        otpDefaultBorderWidth: CGFloat,
        otpFilledBorderWidth: CGFloat,
        otpTextColor: NSColor,
        otpFontSize _: CGFloat,
        otpFont: NSFont,
        isSecureTextEntry _: Bool
    ) {
//        super.init(frame: .init(origin: .zero, size: .init(width: NSScreen.main!.frame.width * 0.8, height: 40)))
        super.init(frame: .init(origin: .zero, size: .init(width: 360, height: 62)))

        self.otpDefaultCharacter = otpDefaultCharacter
        self.otpBackgroundColor = otpBackgroundColor
        self.otpFilledBackgroundColor = otpFilledBackgroundColor
        self.otpCornerRaduis = otpCornerRaduis
        self.otpDefaultBorderColor = otpDefaultBorderColor
        self.otpFilledBorderColor = otpFilledBorderColor
        self.otpDefaultBorderWidth = otpDefaultBorderWidth
        self.otpFilledBorderWidth = otpFilledBorderWidth
        self.otpTextColor = otpTextColor
//        self.otpFontSize = otpFontSize
        self.otpFont = otpFont
//        self.isSecureTextEntry = isSecureTextEntry

        configure(with: slotsCount)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
