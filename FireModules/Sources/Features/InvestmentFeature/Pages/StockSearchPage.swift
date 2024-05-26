import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct StockSearchPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        let searchLoadingState: LoadingState<IdentifiedArrayOf<SymbolDisplayEntity>>
        @BindingViewState var searchedTerm: String
        @BindingViewState var isSearchFocus: Bool
    }

    @FocusState var isSearchFocused: Bool
    @State private var store: StoreOf<StockSearchReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, StockSearchReducer.Action>

    public init(store: StoreOf<StockSearchReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        VStack(alignment: .leading) {
            searchBar
            searchedView
            Spacer()
        }
        .navigationBarHidden(true)
        .padding()
        .enableInjection()
    }

    @ViewBuilder private var searchBar: some View {
        WithViewStore(store, observe: { $0 }) { vs in
            HStack {
                TextField("Search stocks", text: vs.$searchedTerm, onEditingChanged: { _ in
                    //                if editing {
                    //                    viewStore.send(.forward(.activeSearch))
                    //                } else {
                    //                    viewStore.send(.forward(.cancelSearch))
                    //                }
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

                Button(action: {
                    isSearchFocused = false
                    viewStore.send(.forward(.cancelButtonTapped))
                }, label: {
                    Text("Cancel")
                })
            }
            .bind(vs.$isSearchFocused, to: $isSearchFocused)
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
        if let assets = viewStore.searchLoadingState.result {
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
                }
                .padding(.vertical, 0)
                .listRowInsets(.zero)
            }
            .listStyle(.plain)
        }
    }
}

extension BindingViewStore<StockSearchReducer.State> {
    var viewState: StockSearchPage.ViewState {
        // swiftformat:disable redundantSelf
        StockSearchPage.ViewState(
            searchLoadingState: self.searchLoadingState,
            searchedTerm: self.$searchedTerm,
            isSearchFocus: self.$isSearchFocused
        )
        // swiftformat:enable redundantSelf
    }
}
