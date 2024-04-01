import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI
import Utilities

public struct InvestmentPortfolioPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        let portfolio: InvestmentPortfolioEntity
        let calculatingAvailableCashState: LoadingState<Money>
    }

    private let store: StoreOf<InvestmentPortfolioReducer>
    @ObservedObject private var viewStore: ViewStore<ViewState, InvestmentPortfolioReducer.Action>

    public init(store: StoreOf<InvestmentPortfolioReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        VStack(alignment: .leading) {
            FireNavBar(
                leading: {
                    DismissButton()
                },
                center: {
                    Text(viewStore.portfolio.name)
                }
            )
            .padding(.horizontal)

            Spacing(size: .size8)
            content
        }
        .frame(maxWidth: .infinity)
        .navigationBarHidden(true)
        .padding(.vertical)
        .task {
            viewStore.send(.forward(.onAppear))
        }
        .fullScreenCover(
            store: store.scope(
                state: \.$destination.investmentTradeImportOptionsRoute,
                action: \.destination.investmentTradeImportOptionsRoute
            )
        ) { InvestmentTradeImportOptionsPage(store: $0) }
        .navigationDestination(
            store: store.scope(
                state: \.$destination.investmentCashBalanceRoute,
                action: \.destination.investmentCashBalanceRoute
            )
        ) { InvestmentCashBalancePage(store: $0) }
        .enableInjection()
    }

    @ViewBuilder
    private var content: some View {
        if viewStore.portfolio.balances.isEmpty {
            emptyState
        } else {
            List {
                availableCash
            }
            .introspect(.list, on: .iOS(.v13, .v14, .v15)) {
                $0.backgroundColor = .white
            }
            .introspect(.list, on: .iOS(.v16, .v17)) {
                $0.backgroundColor = .white
            }
        }
    }

    @ViewBuilder
    private var emptyState: some View {
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

    @ViewBuilder
    private var availableCash: some View {
        if viewStore.calculatingAvailableCashState.isLoading || viewStore.calculatingAvailableCashState.hasResult {
            Section {
                Button {
                    viewStore.send(.forward(.onCashBalanceTapped))
                } label: {
                    HStack {
                        Text(attributedString("Available Cash ", typography: .bodyDefaultBold)
                            + attributedString(
                                viewStore.calculatingAvailableCashState.hasResult
                                    ? viewStore.calculatingAvailableCashState.result!.formattedString
                                    : "$1,000,000.00",
                                typography: .bodyDefault
                            )
                        )
                        .foregroundColor(.coreui.brightGreen)

                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.coreui.brightGreen)
                    }
                }
                .listRowBackground(Color.coreui.forestGreen)
                .listRowBackground(Color.blue)
            }
            .redacted(reason: viewStore.calculatingAvailableCashState.isLoading ? .placeholder : [])
        }
    }

    private func attributedString(_ string: String, typography: Typography) -> AttributedString {
        var str = AttributedString(string)
        str.font = .custom(typography.font, size: typography.fontSize)
        str.kern = typography.kerning

        return str
    }
}

extension BindingViewStore<InvestmentPortfolioReducer.State> {
    var viewState: InvestmentPortfolioPage.ViewState {
        // swiftformat:disable redundantSelf
        InvestmentPortfolioPage.ViewState(
            portfolio: self.portfolio,
            calculatingAvailableCashState: self.calculatingAvailableCashState
        )
        // swiftformat:enable redundantSelf
    }
}
