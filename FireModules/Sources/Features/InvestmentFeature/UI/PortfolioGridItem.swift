import CoreUI
import DomainEntities
import SwiftUI

struct PortfolioGridItem: View {
    let portfolio: InvestmentPortfolioEntity
    let onTap: () -> Void

    init(portfolio: InvestmentPortfolioEntity, onTap: @escaping () -> Void) {
        self.portfolio = portfolio
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                Text(portfolio.name)
                    .typography(.titleSmall)
                Rectangle()
                    .frame(height: 0)
                    .frame(maxWidth: .infinity)
                Spacing(size: .size4)
                Text(portfolio.totalValue.formattedString)
                    .typography(.titleBody)
                    .foregroundColor(.coreui.forestGreen)
                Spacing(size: .size4)
                Text("$4,533.90 (+4.52%)")
                    .typography(.bodyDefault)
                    .foregroundColor(Color.green)
            }
        }
        .fireButtonStyle(type: .secondary(shape: .roundedCorner))
    }
}
