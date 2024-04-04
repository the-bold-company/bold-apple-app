import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct StockSearchPage: View {
    @ObserveInjection private var iO

    @FocusState var isSearchFocused: Bool

    struct ViewState: Equatable {
        let isSearchActive: Bool
        let searchState: LoadingState<IdentifiedArrayOf<SymbolDisplayEntity>>
        @BindingViewState var searchedTerm: String
    }

    let store: StoreOf<StockSearchReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, StockSearchReducer.Action>

    public init(store: StoreOf<StockSearchReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        VStack(alignment: .leading) {
            FireNavBar(
                leading: {
                    DismissButton()
                }
            )
            Text("Add a manual transaction by searching for a stock")
                .typography(.titleScreen)
            Spacing(size: .size8)
            Text("Just search for the stock and get started. Fast and easy but some manual work needed")
                .typography(.bodyDefault, ignoreLineSpacing: true)
            searchBar
            searchedView
            Spacer()
        }
        .navigationBarHidden(true)
        .padding()
        .enableInjection()
    }

    @ViewBuilder private var searchBar: some View {
        HStack {
            TextField("Search stocks", text: viewStore.$searchedTerm, onEditingChanged: { editing in
                if editing {
                    viewStore.send(.forward(.activeSearch))
                } else {
                    viewStore.send(.forward(.cancelSearch))
                }
            })
            .autocorrectionDisabled()
            .padding(.vertical, 10)
            .padding(.leading, 40)
            .padding(.trailing, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .focused($isSearchFocused)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
            )

            if viewStore.isSearchActive {
                Button(action: {
                    isSearchFocused = false
                }, label: {
                    Text("Cancel")
                })
            }
        }
    }

    @ViewBuilder
    private var trendingStocks: some View {
        List {
            Text("Trending")
                .typography(.bodyDefaultBold)
                .foregroundColor(Color(uiColor: .systemGray))
                .listRowInsets(.zero)
                .listRowSeparator(.hidden)
                .listRowSpacing(0)
            Section {
                ForEach(1 ..< 11) {
                    Text("\($0)")
                }
//                    .padding(.horizontal, 0)
            }
            .padding(.vertical, 0)
            .listRowInsets(.zero)
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    private var searchedView: some View {
        if let assets = viewStore.searchState.result {
            List {
                Section {
                    ForEach(assets) { asset in

                        Button {
//                            viewStore.send(.forward(.openCurrencyPicker))
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
//                                    Text("\(asset.symbol.symbol)")
                                    Text(asset.symbol.symbol)
                                        .typography(.bodyLargeBold)
                                        .foregroundColor(.coreui.forestGreen)
                                    Spacing(size: .size4)
                                    Text(asset.instrumentName)
                                        .typography(.titleSmall)
                                        .foregroundColor(.coreui.forestGreen)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.coreui.forestGreen)
                            }
                            .padding(.vertical(4))
                        }
                    }
                    //                    .padding(.horizontal, 0)
                }
                .padding(.vertical, 0)
                .listRowInsets(.zero)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}

extension BindingViewStore<StockSearchReducer.State> {
    var viewState: StockSearchPage.ViewState {
        // swiftformat:disable redundantSelf
        StockSearchPage.ViewState(
            isSearchActive: self.isSearchActive,
            searchState: self.searchState,
            searchedTerm: self.$searchedTerm
        )
        // swiftformat:enable redundantSelf
    }
}
