import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct InvestmentCashBalancePage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        let portfolio: InvestmentPortfolioEntity
        let transactionHistoryLoadingState: LoadingState<[InvestmentTransactionEntity]>
    }

    let store: StoreOf<InvestmentCashBalanceReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, InvestmentCashBalanceReducer.Action>

    public init(store: StoreOf<InvestmentCashBalanceReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        VStack(alignment: .leading) {
            navBar
            Spacing(size: .size8)

            List {
                availableCash
                addTransactionButton
                transactionHistory
            }
            .listStyle(.plain)
        }
        .navigationBarHidden(true)
        .padding(.vertical)
        .task {
            viewStore.send(.forward(.onAppear))
        }
        .enableInjection()
    }

    @ViewBuilder
    private var navBar: some View {
        FireNavBar(
            leading: {
                DismissButton()
            },
            center: {
                VStack {
                    Text("Available cash")
                        .typography(.titleSmall)
                    Text("Total balance: $29,549")
                        .typography(.titleSmall)
                }
            }
        )
        .padding(.horizontal)
    }

    @ViewBuilder
    private var availableCash: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    Spacing(size: .size12)
                    ForEach(viewStore.portfolio.balances.map { IdentifiableWrapper(value: $0) }) {
                        AvailableCashItem(money: $0.value)
                    }
                }
            }
            .listRowInsets(.zero)
            .listRowSeparator(.hidden)
            .padding(.horizontal, 0)
            .frame(height: 80)
        }
    }

    @ViewBuilder
    private var addTransactionButton: some View {
        Section {
            HStack(spacing: 8) {
                Button(action: {
                    //            viewStore.send(.forward(.sendMoneyButtonTapped))
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.coreui.forestGreen)
                }
                .fireButtonStyle()
                .clipShape(Circle())

                Text("Add transaction")
                    .typography(.titleSmall)
            }
            .listRowSeparator(.hidden)
        }
    }

    @ViewBuilder
    private var transactionHistory: some View {
        if viewStore.transactionHistoryLoadingState.hasResult {
            Section {
                ForEach(viewStore.transactionHistoryLoadingState.result!) {
                    InvestmentTransactionItem(transaction: $0)
                }
            }
        }
    }
}

extension BindingViewStore<InvestmentCashBalanceReducer.State> {
    var viewState: InvestmentCashBalancePage.ViewState {
        // swiftformat:disable redundantSelf
        InvestmentCashBalancePage.ViewState(
            portfolio: self.portfolio,
            transactionHistoryLoadingState: self.transactionHistoryLoadingState
        )
        // swiftformat:enable redundantSelf
    }
}
