import CoreUI
import DomainEntities
import SwiftUI

struct InvestmentTransactionItem: View {
    let transaction: InvestmentTransactionEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Spacing(size: .size8)
            content
        }
        .padding(.zero)
        .listRowSeparator(.hidden)
    }

    @ViewBuilder
    private var header: some View {
        HStack {
            Text(transaction.type.displayText)
                .typography(.titleSmall)
                .bold()
                .padding(.symetric(horizontal: 8, vertical: 4))
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(colorBasedOnTransactionType(transaction.type).opacity(0.2)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(
                                    colorBasedOnTransactionType(transaction.type),
                                    lineWidth: 1
                                )
                        }
                )

            Text("30 Mar 2024 at 16:15")
                .typography(.titleSmall)
        }
    }

    @ViewBuilder
    private var content: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 10, alignment: .leading),
                GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 10, alignment: .leading),
            ],
            spacing: 10,
            content: {
                VStack(alignment: .leading) {
                    Text("Amount")
                        .typography(.titleSmall)
                        .foregroundColor(.coreui.darkGold)

                    Text(transaction.amount.formattedString)
                        .typography(.bodyDefaultBold)
                }

                VStack(alignment: .leading) {
                    Text("Currency")
                        .typography(.titleSmall)
                        .foregroundColor(.coreui.darkGold)
                    Text(transaction.amount.currency.currencyCodeString)
                        .typography(.bodyDefaultBold)
                }

                if let notes = transaction.notes {
                    VStack(alignment: .leading) {
                        Text("Notes")
                            .typography(.titleSmall)
                            .foregroundColor(.coreui.darkGold)
                        Text(notes)
                            .typography(.bodyDefaultBold)
                    }
                }
            }
        )
        .padding(12)
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(
                    Color.coreui.forestGreen,
                    lineWidth: 0.5
                )
        }
    }

    private func colorBasedOnTransactionType(_ type: InvestmentTransactionType) -> Color {
        switch type {
        case .deposit:
            return .green
        case .withdraw:
            return .red
        }
    }
}
