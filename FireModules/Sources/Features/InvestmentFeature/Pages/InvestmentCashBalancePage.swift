import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct InvestmentCashBalancePage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        let portfolio: InvestmentPortfolioEntity
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
            availableCash
        }
        .navigationBarHidden(true)
        .padding(.vertical)
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
        ScrollView(.horizontal) {
            LazyHStack(spacing: 8) {
                ForEach(viewStore.portfolio.balances.map { IdentifiableWrapper(value: $0) }) {
                    AvailableCashItem(money: $0.value)
                }
            }
            .padding(.horizontal)
        }
    }
}

extension BindingViewStore<InvestmentCashBalanceReducer.State> {
    var viewState: InvestmentCashBalancePage.ViewState {
        // swiftformat:disable redundantSelf
        InvestmentCashBalancePage.ViewState(
            portfolio: self.portfolio
        )
        // swiftformat:enable redundantSelf
    }
}

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

public struct IdentifiableWrapper<Item>: Identifiable {
    public let id: UUID
    public let value: Item

    public init(value: Item) {
        self.id = UUID()
        self.value = value
    }
}
