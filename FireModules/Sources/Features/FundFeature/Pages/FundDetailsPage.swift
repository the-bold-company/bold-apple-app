//
//  FundDetailsPage.swift
//
//
//  Created by Hien Tran on 15/01/2024.
//

import Charts
import ComposableArchitecture
import CoreUI
import CurrencyKit
import DomainEntities
import RecordTransactionFeature
import SwiftUI

public struct FundDetailsPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        var fund: FundEntity
        var fundDetailsLoadingState: LoadingState<FundEntity>
        var fundDeletionState: LoadingState<UUID>
        var isTransactionsLoading: Bool
        var transactions: IdentifiedArrayOf<TransactionEntity>
    }

    let store: StoreOf<FundDetailsReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, FundDetailsReducer.Action>

    public init(
        store: StoreOf<FundDetailsReducer>
    ) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.viewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.fundDeletionState.isLoading) {
            VStack(alignment: .leading) {
                DismissButton().padding(.all, 16)

                Spacing(size: .size8)
                List {
                    balance
                    fundInfo
                    transactionList
                    deleteFundButton
                }
            }
        }
        .hideNavigationBar()
        .task {
            viewStore.send(.forward(.loadTransactionHistory))
        }
        .navigationDestination(
            store: store.scope(
                state: \.$destination.sendMoney,
                action: \.destination.sendMoney
            )
        ) { SendMoneyPage(store: $0) }
        .enableInjection()
    }

    @ViewBuilder
    var actionItems: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Button(action: {
                    viewStore.send(.forward(.sendMoneyButtonTapped))
                }) {
                    Image(systemName: "arrow.up")
                        .foregroundColor(Color.coreui.forestGreen)
                }
                .fireButtonStyle()
                .clipShape(Circle())

                Text("Add")
                    .font(.custom(FontFamily.Inter.regular, size: 12))
            }
            Spacer()
        }
    }

    @ViewBuilder
    var balance: some View {
        Section {
            VStack(alignment: .leading) {
                Text(viewStore.fund.name).typography(.titleBody)

                Spacing(size: .size16)

                HStack(alignment: .top, spacing: 4) {
                    Text(getCurrencySymbol(isoCurrencyCode: viewStore.fund.currency))
                        .typography(.bodyLarge)
                        .alignmentGuide(.top, computeValue: { _ in -2 })

                    Text("\(formatNumber(viewStore.fund.balance))")
                        .typography(.titleSection)
                        .alignmentGuide(.top, computeValue: { dimensions in dimensions[.top] })
                }

                Spacing(size: .size4)

                HStack(alignment: .top, spacing: 32) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("1 day")
                            .font(.custom(FontFamily.Inter.light, size: 12))
                            .textCase(.uppercase)

                        Text("+$176 (5%)")
                            .typography(.bodyLarge)
                            .foregroundColor(.green)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("1 month")
                            .font(.custom(FontFamily.Inter.light, size: 12))
                            .textCase(.uppercase)

                        Text("+$3.38K (4%)")
                            .typography(.bodyLarge)
                            .foregroundColor(.green)
                    }
                }
                .redacted(reason: viewStore.fundDetailsLoadingState.isLoading ? .placeholder : [])

                Spacing(size: .size24)
                actionItems
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
            )
        }
    }

    @ViewBuilder
    var fundInfo: some View {
        Section {
            FundInfoItem(
                isLoading: viewStore.fundDetailsLoadingState.isLoading,
                title: "Currency",
                value: viewStore.fund.currency
            )
            FundInfoItem(
                isLoading: viewStore.fundDetailsLoadingState.isLoading,
                title: "Type",
                value: viewStore.fund.fundType.rawValue.capitalized
            )
        }
    }

    @ViewBuilder
    private var transactionList: some View {
        Section {
            VStack(alignment: .leading) {
                HStack {
                    Text("Transactions history").typography(.bodyLarge)
                    Spacer()
                }
                Spacing(height: .size16)
                ForEach(
                    viewStore.isTransactionsLoading
                        ? IdentifiedArray(uniqueElements: [
                            TransactionEntity.mock(id: UUID()),
                            TransactionEntity.mock(id: UUID()),
                            TransactionEntity.mock(id: UUID()),
                            TransactionEntity.mock(id: UUID()),
                            TransactionEntity.mock(id: UUID()),
                        ])
                        : viewStore.transactions,
                    id: \.id
                ) {
                    TransactionItemView(
                        transaction: $0,
                        isLoading: viewStore.isTransactionsLoading
                    )
                }
            }
        }
    }

    @ViewBuilder
    var deleteFundButton: some View {
        Button(action: {
            viewStore.send(.forward(.deleteFundButtonTapped))
        }) {
            Text("Delete this fund")
                .frame(maxWidth: .infinity)
        }
        .fireButtonStyle(type: .secondary(shape: .roundedCorner))
    }

    private func formatNumber(_ value: Decimal?) -> String {
        guard let value else { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? ""
    }

    private func getCurrencySymbol(isoCurrencyCode: String?) -> String {
        guard let currencyCode = isoCurrencyCode else { return "" }
        return CurrencyKit.shared.findSymbol(for: currencyCode) ?? currencyCode
    }
}

extension BindingViewStore<FundDetailsReducer.State> {
    var viewState: FundDetailsPage.ViewState {
        // swiftformat:disable redundantSelf
        FundDetailsPage.ViewState(
            fund: self.fund,
            fundDetailsLoadingState: self.fundDetailsLoadingState,
            fundDeletionState: self.fundDeletionState,
            isTransactionsLoading: self.transactionsLoadingState.isLoading,
            transactions: self.transactions
        )
        // swiftformat:enable redundantSelf
    }
}
