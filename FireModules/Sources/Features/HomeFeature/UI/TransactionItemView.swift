//
//  TransactionItemView.swift
//
//
//  Created by Hien Tran on 30/01/2024.
//

import DomainEntities
import Inject
import SwiftUI

struct TransactionItemView: View {
    @ObserveInjection private var iO

    let transaction: TransactionEntity
    let isLoading: Bool
    let from: String
    let to: String?

    init(
        transaction: TransactionEntity,
        isLoading: Bool,
        from: String,
        to: String?
    ) {
        self.transaction = transaction
        self.isLoading = isLoading
        self.from = from
        self.to = to
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("- \(getCurrencySymbol(isoCurrencyCode: transaction.currency)) \(formatNumber(transaction.amount))")
                    .foregroundColor(.coreui.darkCharcoal)
                    .typography(.bodyLarge)
                if let description = transaction.description {
                    Text(description)
                        .typography(.bodyDefault)
                        .foregroundColor(.coreui.darkCharcoal)
                }
                Text("Source: \(from)")
                    .typography(.bodyDefault)
                    .foregroundColor(.coreui.darkCharcoal)
                if let destination = to {
                    Text("Destination: \(destination)")
                        .typography(.bodyDefault)
                        .foregroundColor(.coreui.darkCharcoal)
                }
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .enableInjection()
    }
}

// #Preview {
//    TransactionItemView()
// }
