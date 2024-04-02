import CoreUI
import DomainEntities
import SwiftUI

struct AvailableCashItem: View {
    let money: Money

    var body: some View {
        VStack {
            Text(money.formattedString)
                .typography(.titleSmall)
                .bold()
                .foregroundColor(.coreui.brightGreen)
        }
        .padding()
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    Color.coreui.forestGreen
                        .opacity(0.8)
                )
        )
    }
}
