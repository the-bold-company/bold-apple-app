import ComposableArchitecture
import CoreUI
import SwiftUI

public struct InvestmentPortfolioPage: View {
    @ObserveInjection private var iO

    private let store: StoreOf<InvestmentPortfolioReducer>

    public init(store: StoreOf<InvestmentPortfolioReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                FireNavBar(
                    leading: {
                        DismissButton()
                    },
                    center: {
                        Text(viewStore.portfolio.name)
                    }
                )

                Spacing(size: .size8)
                VStack {
                    Spacer()
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)

                    Spacer().frame(height: 20)

                    Text("Add transaction to your new portfolio")
                        .typography(.bodyDefaultBold)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button {
                        viewStore.send(.forward(.navigateToTradeImportOptions))
                    } label: {
                        Text("Add transaction")
                    }
                    .fireButtonStyle()

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarHidden(true)
            .padding()
            .fullScreenCover(
                store: store.scope(
                    state: \.$destination.investmentTradeImportOptionsRoute,
                    action: \.destination.investmentTradeImportOptionsRoute
                )
            ) { InvestmentTradeImportOptionsPage(store: $0) }
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.addTransactionRoute,
                    action: \.destination.addTransactionRoute
                )
            ) { RecordPortfolioTransactionPage(store: $0) }
        }
        .enableInjection()
    }
}
