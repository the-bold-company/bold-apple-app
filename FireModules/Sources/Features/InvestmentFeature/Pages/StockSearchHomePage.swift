import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct StockSearchHomePage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        @BindingViewState var searchedTerm: String
    }

    let store: StoreOf<StockSearchHomeReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, StockSearchHomeReducer.Action>

    public init(store: StoreOf<StockSearchHomeReducer>) {
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
            intro
            searchBar
            trendingStocks
            Spacer()
        }
        .navigationBarHidden(true)
        .padding()
        .fullScreenCover(
            store: store.scope(
                state: \.$destination.stockSearchRoute,
                action: \.destination.stockSearchRoute
            )
        ) { StockSearchPage(store: $0) }
        .enableInjection()
    }

    @ViewBuilder
    private var intro: some View {
        Group {
            Text("Add a manual transaction by searching for a stock")
                .typography(.titleScreen)
            Spacing(size: .size8)
            Text("Just search for the stock and get started. Fast and easy but some manual work needed")
                .typography(.bodyDefault, ignoreLineSpacing: true)
        }
    }

    @ViewBuilder private var searchBar: some View {
        TextField("Search stocks", text: viewStore.$searchedTerm)
            .disabled(true)
            .autocorrectionDisabled()
            .padding(.vertical, 10)
            .padding(.leading, 40)
            .padding(.trailing, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
            )
            .onTapGesture {
                viewStore.send(.forward(.activeSearch))
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
}

extension BindingViewStore<StockSearchHomeReducer.State> {
    var viewState: StockSearchHomePage.ViewState {
        // swiftformat:disable redundantSelf
        StockSearchHomePage.ViewState(
            searchedTerm: self.$searchedTerm
        )
        // swiftformat:enable redundantSelf
    }
}
