//
//  TransactionItemView.swift
//
//
//  Created by Hien Tran on 03/02/2024.
//

import CoreUI
import CurrencyKit
import Inject
import SharedModels
import SwiftUI

struct TransactionItemView: View {
    @ObserveInjection private var iO

    let transaction: TransactionEntity
    let isLoading: Bool

    init(
        transaction: TransactionEntity,
        isLoading: Bool
    ) {
        self.transaction = transaction
        self.isLoading = isLoading
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                if transaction.type == .in {
                    Text("Money in")
                        .typography(.bodyDefaultBold)
                        .foregroundColor(Color.green)
                } else if transaction.type == .out {
                    Text("Money out")
                        .typography(.bodyDefaultBold)
                        .foregroundColor(.coreui.darkCharcoal)
                }

                Spacing(size: .size4)

                if let description = transaction.description {
                    Text(description)
                        .typography(.bodyDefault)
                        .foregroundColor(.coreui.darkCharcoal)
                        .truncationMode(.tail)
                        .lineLimit(1)
                }
            }

            Spacer()

            if transaction.type == .in {
                Text("\(getCurrencySymbol(isoCurrencyCode: transaction.currency)) \(formatNumber(transaction.amount))")
                    .foregroundColor(Color.green)
                    .typography(.bodyLargeBold)
            } else if transaction.type == .out {
                Text("- \(getCurrencySymbol(isoCurrencyCode: transaction.currency)) \(formatNumber(transaction.amount))")
                    .foregroundColor(.coreui.darkCharcoal)
                    .typography(.bodyLargeBold)
            }
        }
        .padding(.vertical(8))
        .redacted(reason: isLoading ? .placeholder : [])
        .enableInjection()
    }
}

// #Preview {
//    TransactionItemView()
// }

// TODO: Move this logic to DTO
func formatNumber(_ value: Decimal?) -> String {
    guard let value else { return "" }
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    formatter.locale = Locale(identifier: "en_US")
    return formatter.string(from: NSDecimalNumber(decimal: value)) ?? ""
}

func getCurrencySymbol(isoCurrencyCode: String?) -> String {
    guard let currencyCode = isoCurrencyCode else { return "" }
    return CurrencyKit.shared.findSymbol(for: currencyCode) ?? currencyCode
}
