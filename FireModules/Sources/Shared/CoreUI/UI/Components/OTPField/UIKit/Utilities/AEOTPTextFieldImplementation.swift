//
//  AEOTPTextFieldImplementation.swift
//  ViberTemplate
//
//  Created by Abdelrhman Eliwa on 09/05/2021.
//

import UIKit

class AEOTPTextFieldImplementation: NSObject, UITextFieldDelegate {
    weak var implementationDelegate: AEOTPTextFieldImplementationProtocol?

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn _: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let characterCount = textField.text?.count else { return false }

        // Check if the replacement string is a valid number
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)

        return allowedCharacters.isSuperset(of: characterSet)
            && characterCount < implementationDelegate?.digitalLabelsCount ?? 0 || string == ""
    }
}
