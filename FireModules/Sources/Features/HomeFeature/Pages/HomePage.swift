//
//  HomePage.swift
//
//
//  Created by Hien Tran on 21/11/2023.
//

import Charts
import ComposableArchitecture
import CoreUI
import Networking
import SwiftUI

public struct HomePage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        var isLoadingNetworth: Bool
        var networth: NetworthResponse?
        var networthError: String?

        var isLoadingFunds: Bool
        var funds: [CreateFundResponse]?
        var fundsError: String?
    }

    @State var users = [String]()

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
            }
        }
        .navigationBarHidden(false)
//        .navigationBarItems(
//            leading: Button(action: {
//                            self.isShowingSettings.toggle()
//            }) {
//                Image(systemName: "gearshape")
//            },
//            trailing: Menu {
//                // Dropdown options for base currency
//                Button("USD") {
//                    // Handle selection
//                        self.baseCurrency = "USD"
//                }
//                Button("EUR") {
//                    // Handle selection
//                        self.baseCurrency = "EUR"
//                }
//            } label: {
//                Image(systemName: "arrowtriangle.down.fill")
//                    .foregroundColor(.blue)
//                    .padding(.trailing)
//            }
//        )
        .background(Color(red: 246 / 255, green: 246 / 255, blue: 246 / 255))
        .task {
            viewStore.send(.onAppear)
        }
        .enableInjection()
    }

    @ViewBuilder
    private var networth: some View {
        Section {
            LazyVStack(alignment: .leading) {
                Text("Networth").typography(.bodyLarge)

                HStack(alignment: .top, spacing: 4) {
                    Text(getCurrencySymbol(isoCurrencyCode: viewStore.networth?.currency))
                        .typography(.bodyLarge)
                        .alignmentGuide(.top, computeValue: { _ in -2 })

                    Text("\(formatNumber(viewStore.networth?.networth))")
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
        .redacted(reason: viewStore.isLoadingNetworth ? .placeholder : [])
    }

    @ViewBuilder
    private var fundList: some View {
        Section {
            LazyVStack(alignment: .leading) {
                HStack {
                    Text("Funds").typography(.bodyLarge)
                    Spacer()
                    Button(action: {
                        // Add new fund
                    }) {
                        Image(systemName: "rectangle.stack.badge.plus")
                    }
                }
                Spacing(height: .size16)
                ForEach(
                    viewStore.isLoadingFunds
                        ? CreateFundResponse.mockList
                        : viewStore.funds!,
                    id: \.id
                ) { fund in
                    FundItemView(fund: fund, isLoading: viewStore.isLoadingFunds)
                        .onTapGesture {
                            // Handle tap
                        }
                }
            }
        }
    }
}

extension BindingViewStore<HomeReducer.State> {
    var viewState: HomePage.ViewState {
        // swiftformat:disable redundantSelf
        HomePage.ViewState(
            isLoadingNetworth: self.isLoadingNetworth,
            networth: self.networth,
            networthError: self.networthError,
            isLoadingFunds: self.isLoadingFunds,
            funds: self.funds,
            fundsError: self.fundsError
        )
        // swiftformat:enable redundantSelf
    }
}
