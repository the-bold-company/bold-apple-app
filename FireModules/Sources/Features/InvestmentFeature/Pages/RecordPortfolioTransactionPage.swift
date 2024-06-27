import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct RecordPortfolioTransactionPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        let currency: Currency
        @BindingViewState var tradeTime: Date
        @BindingViewState var amount: Int
        @BindingViewState var notes: String
        let transactionType: TransactionType
        let isFormValid: Bool
        let loadingState: LoadingState<InvestmentTransactionEntity>
    }

    private let store: StoreOf<RecordPortfolioTransactionReducer>
    @ObservedObject private var viewStore: ViewStore<ViewState, RecordPortfolioTransactionReducer.Action>

    public init(store: StoreOf<RecordPortfolioTransactionReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    private var amountformatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = viewStore.currency.currencyLocale
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.loadingState.isLoading) {
            VStack(alignment: .leading) {
                navBar
                Spacing(size: .size16)
                transactionTypeSelection
                inputs
                addTransactionButton
            }
            .hideNavigationBar()
            .padding()
            .alert(store: store.scope(
                state: \.$destination.recordTransactionFailureAlert,
                action: \.destination.recordTransactionFailureAlert
            ))
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.currencyPickerRoute,
                    action: \.destination.currencyPickerRoute
                )
            ) { CurrencyPickerPage(store: $0) }
        }
        .enableInjection()
    }

    @ViewBuilder
    private var transactionTypeSelection: some View {
        HStack(alignment: .center, spacing: 12) {
            Button {
                viewStore.send(.forward(.selectDepositTransactionType))
            } label: {
                Text("Deposit")
                    .frame(maxWidth: .infinity)
            }
            .secondaryButtomCustomBorderStyle(borderColor: Color.green, isActive: viewStore.transactionType == .deposit)

            Button {
                viewStore.send(.forward(.selectWithdrawTransactionType))
            } label: {
                Text("Withdraw")
                    .frame(maxWidth: .infinity)
            }
            .secondaryButtomCustomBorderStyle(borderColor: Color.red, isActive: viewStore.transactionType == .withdraw)
        }
        .padding(.horizontal(16))
//        .frame(maxWidth: .infinity)
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
    }

    @ViewBuilder var inputs: some View {
        List {
            Button {
                viewStore.send(.forward(.openCurrencyPicker))
            } label: {
                VStack(alignment: .leading) {
                    Text("Currency")
                        .typography(.titleSmall)
                        .foregroundColor(.coreui.forestGreen)
                    Spacing(size: .size4)
                    HStack {
                        Text(viewStore.currency.currencyCodeString)
                            .typography(.bodyLargeBold)
                            .foregroundColor(.coreui.forestGreen)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.coreui.forestGreen)
                    }
                }
                .padding(.vertical(4))
            }

            VStack(alignment: .leading) {
                Text("Date & time")
                    .typography(.titleSmall)
                    .foregroundColor(.coreui.forestGreen)
                Spacing(size: .size4)
                HStack {
                    DatePicker(
                        "",
                        selection: viewStore.$tradeTime,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .labelsHidden()
                    Spacer()
                }
            }
            .padding(.vertical(4))

            VStack(alignment: .leading) {
                Text("Amount")
                    .typography(.titleSmall)
                    .foregroundColor(.coreui.forestGreen)
                Spacing(size: .size4)
                #if os(iOS)
                    CurrencyField(value: viewStore.$amount, formatter: amountformatter)
                        .keyboardType(.decimalPad)
                #endif
            }
            .padding(.vertical(4))

            VStack(alignment: .leading) {
                Text("Notes")
                    .typography(.titleSmall)
                    .foregroundColor(.coreui.forestGreen)
                Spacing(size: .size4)
                TextField("", text: viewStore.$notes)
                    .font(.custom(Typography.bodyDefault.font, size: Typography.bodyDefault.fontSize))
                    .autocorrectionDisabled()
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical(4))
        }
        .listStyle(.plain)
    }

    @ViewBuilder var addTransactionButton: some View {
        Button {
            viewStore.send(.forward(.addTransactionButtonTapped))
        } label: {
            Text("Add transaction")
                .frame(maxWidth: .infinity)
        }
        .fireButtonStyle(isActive: viewStore.isFormValid)
    }
}

extension BindingViewStore<RecordPortfolioTransactionReducer.State> {
    var viewState: RecordPortfolioTransactionPage.ViewState {
        // swiftformat:disable redundantSelf
        RecordPortfolioTransactionPage.ViewState(
            currency: self.currency,
            tradeTime: self.$tradeTime,
            amount: self.$amount,
            notes: self.$notes,
            transactionType: self.transactionType,
            isFormValid: self.isFormValid,
            loadingState: self.submissionState
        )
        // swiftformat:enable redundantSelf
    }
}
