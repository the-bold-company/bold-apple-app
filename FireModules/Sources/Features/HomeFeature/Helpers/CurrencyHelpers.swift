//
//  CurrencyHelpers.swift
//
//
//  Created by Hien Tran on 11/01/2024.
//

import CurrencyKit
import Foundation

// TODO: Move this logic to DTO
func formatNumber(_ value: Double?) -> String {
    guard let value else { return "" }
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.locale = Locale(identifier: "en_US")
    return formatter.string(from: NSNumber(value: value)) ?? ""
}

func getCurrencySymbol(isoCurrencyCode: String?) -> String {
    guard let currencyCode = isoCurrencyCode else { return "" }
    return CurrencyKit.shared.findSymbol(for: currencyCode) ?? currencyCode
}
