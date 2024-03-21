import ComposableArchitecture
import CoreUI
import SwiftUI

public struct InvestmentPortfolioPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {}

    let store: StoreOf<InvestmentPortfolioReducer>
//    @ObservedObject var viewStore: ViewStore<ViewState, InvestmentPortfolioReducer.Action>

    public init(store: StoreOf<InvestmentPortfolioReducer>) {
        self.store = store
//        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 12) {
                    DismissButton()

                    Spacer()

                    Text(viewStore.portfolio.name)

                    Spacer()
                }

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
                        //                    showingAlert.toggle()
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
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.addTransactionRoute,
                    action: \.destination.addTransactionRoute
                )
            ) { AddPortfolioTransactionPage(store: $0) }
        }
        .enableInjection()
    }
}

extension BindingViewStore<InvestmentPortfolioReducer.State> {
    var viewState: InvestmentPortfolioPage.ViewState {
        // swiftformat:disable redundantSelf
        InvestmentPortfolioPage.ViewState(
            //            portfolioName: self.$portfolioName
        )
        // swiftformat:enable redundantSelf
    }
}
