//
//  TransactionOverview.swift
//  Fire
//
//  Created by Hien Tran on 19/02/2024.
//

import SwiftUI

struct TransactionOverview: View {
    let source: SourceFundIntentEntity
    let destination: DestinationFundIntentEntity
    let amount: Decimal

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("From:")
                Spacer()
                Text(source.name)
                    .font(.title3)
            }
            if !destination.representsNull {
                HStack {
                    Text("To:")
                    Spacer()
                    Text(destination.name)
                        .font(.title3)
                }
            }
            HStack {
                Text("Amount:")
                Spacer()
                Text("$ \(formatNumber(amount))")
                    .font(.title3)
            }
        }
        .padding()
    }
}

func formatNumber(_ value: Decimal?) -> String {
    guard let value else { return "" }
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.locale = Locale(identifier: "en_US")
    return formatter.string(from: NSDecimalNumber(decimal: value)) ?? ""
}

#Preview {
    TransactionOverview(
        source: SourceFundIntentEntity(
            id: UUID(),
            name: "HSBC Saving",
            balance: 100_000_000
        ),
        destination: DestinationFundIntentEntity(
            id: UUID(),
            name: "Wise Wallet",
            balance: 100_000
        ),
        amount: 5_000_000
    )
}
