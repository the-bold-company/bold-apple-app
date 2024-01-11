//
//  FundItemView.swift
//
//
//  Created by Hien Tran on 10/01/2024.
//

import CoreUI
import Networking
import SwiftUI

struct FundItemView: View {
    @ObserveInjection private var iO

    let fund: CreateFundResponse
    let isLoading: Bool

    init(fund: CreateFundResponse, isLoading: Bool) {
        self.fund = fund
        self.isLoading = isLoading
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(fund.name)
                    .typography(.bodyLarge)
                    .foregroundColor(.coreui.darkCharcoal)
                Text("\(getCurrencySymbol(isoCurrencyCode: fund.currency)) \(formatNumber(fund.balance))")
                    .foregroundColor(.coreui.darkCharcoal)
                    .typography(.bodyDefault)
            }

            Spacer()

            Text(fund.fundType.rawValue.capitalized)
                .typography(.bodyDefaultBold)
                .padding(4)
                .background(Color.coreui.brightGreen)
                .foregroundColor(.coreui.forestGreen)
                .cornerRadius(4)
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .enableInjection()
    }
}

#Preview {
    Group {
        FundItemView(
            fund: CreateFundResponse.mockList.first!, // swiftlint:disable:this force_unwrapping
            isLoading: true
        )
        FundItemView(
            fund: CreateFundResponse.mockList.first!, // swiftlint:disable:this force_unwrapping
            isLoading: false
        )
    }
}
