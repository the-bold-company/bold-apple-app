//
//  HomePage.swift
//
//
//  Created by Hien Tran on 21/11/2023.
//

import Charts
import ComposableArchitecture
import CoreUI
import DomainEntities
import FundFeature
import InvestmentFeature
import SwiftUI

public struct HomePage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        var networthLoadingState: LoadingState<NetworthEntity>
        var fundLoadingState: LoadingState<[FundEntity]>
        var fundList: IdentifiedArrayOf<FundEntity>
        var isTransactionLoading: Bool
        var transactions: IdentifiedArrayOf<TransactionEntity>
    }

    let store: StoreOf<HomeReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, HomeReducer.Action>

    public init(store: StoreOf<HomeReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            List {
                networth
                fundList
                investment
                transactionList
            }
        }
//            .hideNavigationBar()
//            .background(Color(red: 246 / 255, green: 246 / 255, blue: 246 / 255))
//            .navigationDestination(
//                store: store.scope(
//                    state: \.$destination.fundDetailsRoute,
//                    action: \.destination.fundDetailsRoute
//                )
//            ) { FundDetailsPage(store: $0) }
//            .navigationDestination(
//                store: store.scope(
//                    state: \.$destination.fundCreationRoute,
//                    action: \.destination.fundCreationRoute
//                )
//            ) { FundCreationPage(store: $0) }
//            .navigationDestination(
//                store: store.scope(
//                    state: \.$destination.investmentHomeRoute,
//                    action: \.destination.investmentHomeRoute
//                )
//            ) { InvestmentHomePage(store: $0) }
        .task {
//            viewStore.send(.forward(.loadPortfolio))
//            viewStore.send(.forward(.loadFundList))
//            viewStore.send(.forward(.loadTransactionHistory))
        }
        .enableInjection()
    }

    @ViewBuilder
    private var networth: some View {
        Section {
            LazyVStack(alignment: .leading) {
                Text("Networth").typography(.bodyLarge)

                HStack(alignment: .top, spacing: 4) {
                    Text(getCurrencySymbol(isoCurrencyCode: viewStore.networthLoadingState.result?.currency))
                        .typography(.bodyLarge)
                        .alignmentGuide(.top, computeValue: { _ in -2 })

                    Text("\(formatNumber(viewStore.networthLoadingState.result?.networth))")
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

                Chart {
                    Plot {
                        AreaMark(x: .value("Month", "Jan"), y: .value("Networth", 146))
                            .foregroundStyle(.blue.opacity(0.5).gradient)
                        AreaMark(x: .value("Month", "Feb"), y: .value("Networth", 233.8))
                        AreaMark(x: .value("Month", "Mar"), y: .value("Networth", 17.2))
                        AreaMark(x: .value("Month", "Apr"), y: .value("Networth", 146.8))
                        AreaMark(x: .value("Month", "May"), y: .value("Networth", 120))
                        AreaMark(x: .value("Month", "Jun"), y: .value("Networth", 76.6))
                        AreaMark(x: .value("Month", "Jul"), y: .value("Networth", 16.6))
                        AreaMark(x: .value("Month", "Aug"), y: .value("Networth", 69))
                        AreaMark(x: .value("Month", "Sep"), y: .value("Networth", 75))
                        AreaMark(x: .value("Month", "Oct"), y: .value("Networth", 147.4))
                        AreaMark(x: .value("Month", "Nov"), y: .value("Networth", 30.4))
                        AreaMark(x: .value("Month", "Dec"), y: .value("Networth", 148.6))
                    }
                    .interpolationMethod(.catmullRom)
                }
            }
            .background(Color.white)
            .cornerRadius(8)
        }
        .redacted(reason: viewStore.networthLoadingState.hasResult ? [] : .placeholder)
    }

    @ViewBuilder
    private var fundList: some View {
        Section {
            LazyVStack(alignment: .leading) {
                HStack {
                    Text("Funds").typography(.bodyLarge)
                    Spacer()
                    Button(action: {
                        viewStore.send(.forward(.createFundButtonTapped))
                    }) {
                        Image(systemName: "rectangle.stack.badge.plus")
                    }
                    .buttonStyle(.plain) // Putting a button inside a List row will make the entire row tapable. This is to disable that. Read more: https://www.reddit.com/r/SwiftUI/comments/11v492t/comment/jcrgl2i
                }
                Spacing(height: .size16)
                ForEach(
                    viewStore.fundLoadingState.hasResult
                        ? viewStore.fundList.elements
                        : FundEntity.mockList,
                    id: \.id
                ) { fund in
                    FundItemView(fund: fund, isLoading: !viewStore.fundLoadingState.hasResult)
                        .onTapGesture {
                            viewStore.send(.forward(.fundRowTapped(fund)))
                        }
                }
            }
        }
    }

    @ViewBuilder
    private var transactionList: some View {
        Section {
            VStack(alignment: .leading) {
                HStack {
                    Text("Transactions history").typography(.bodyLarge)
                    Spacer()
                    Button(action: {
                        // view all transactions
                    }) {
                        Image(systemName: "list.dash")
                    }
                    .buttonStyle(.plain) // Putting a button inside a List row will make the entire row tapable. This is to disable that. Read more: https://www.reddit.com/r/SwiftUI/comments/11v492t/comment/jcrgl2i
                }
                Spacing(height: .size16)
                ForEach(
                    viewStore.isTransactionLoading
                        ? IdentifiedArray(uniqueElements: [
                            TransactionEntity.mock(id: UUID()),
                            TransactionEntity.mock(id: UUID()),
                            TransactionEntity.mock(id: UUID()),
                        ])
                        : viewStore.transactions
                ) {
                    TransactionItemView(
                        transaction: $0,
                        isLoading: viewStore.isTransactionLoading,
                        from: viewStore.fundList[id: $0.sourceFundId]?.name ?? "N/A",
                        to: $0.destinationFundId != nil
                            ? viewStore.fundList[id: $0.destinationFundId!]?.name // swiftlint:disable:this force_unwrapping
                            : nil
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var investment: some View {
        Section {
            Button(action: {
                viewStore.send(.forward(.goToInvestmentPortfolio))
            }) {
                Text("Go to investment")
            }
            .buttonStyle(.plain)
        }
    }
}

extension BindingViewStore<HomeReducer.State> {
    var viewState: HomePage.ViewState {
        // swiftformat:disable redundantSelf
        HomePage.ViewState(
            networthLoadingState: self.networthLoadingState,
            fundLoadingState: self.fundLoadingState,
            fundList: self.fundList,
            isTransactionLoading: self.transactionLoadingState.isLoading,
            transactions: self.transactionList
        )
        // swiftformat:enable redundantSelf
    }
}
