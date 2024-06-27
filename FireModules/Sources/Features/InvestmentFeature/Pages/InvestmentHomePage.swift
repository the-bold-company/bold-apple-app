import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct InvestmentHomePage: View {
    @ObserveInjection private var iO

    @State private var showingCreatePorfolioAlert = false

    struct ViewState: Equatable {
        @BindingViewState var portfolioName: String
        let createPortfolioState: LoadingState<InvestmentPortfolioEntity>
        let loadPortfoliosState: LoadingState<[InvestmentPortfolioEntity]>
        let portfolioList: IdentifiedArrayOf<InvestmentPortfolioEntity>
    }

    let store: StoreOf<InvestmentHomeReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, InvestmentHomeReducer.Action>

    public init(store: StoreOf<InvestmentHomeReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.createPortfolioState.isLoading) {
            VStack(alignment: .leading) {
                DismissButton()
                Spacing(size: .size8)

                if viewStore.loadPortfoliosState == .idle {
                    emptyState
                        .hidden()
                } else {
                    contentView
                }
            }
            .frame(maxWidth: .infinity)
            .hideNavigationBar()
            .padding()
            .task {
                viewStore.send(.forward(.onAppear))
            }
            .alert("Enter portfolio name", isPresented: $showingCreatePorfolioAlert) {
                TextField("Enter name", text: viewStore.$portfolioName)
                    .autocorrectionDisabled()
                Button("OK") {
                    viewStore.send(.forward(.submitPortfolioCreationForm))
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("There's a limit of 50 characters.")
            }
            .alert(store:
                store.scope(
                    state: \.$destination.invalidPortfolioCreationAlert,
                    action: \.destination.invalidPortfolioCreationAlert
                )
            )
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.portfolioDetailsRoute,
                    action: \.destination.portfolioDetailsRoute
                )
            ) { InvestmentPortfolioPage(store: $0) }
        }
        .enableInjection()
    }

    @ViewBuilder
    private var emptyState: some View {
        VStack {
            Spacer()
            Image(systemName: "chart.pie")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)

            Spacer().frame(height: 20)

            Text("You don't have any portfolio")
                .typography(.bodyDefaultBold)
                .multilineTextAlignment(.center)
                .padding()

            Button {
                showingCreatePorfolioAlert = true
            } label: {
                Text("Create portfolio")
            }
            .fireButtonStyle()

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var contentView: some View {
        if viewStore.loadPortfoliosState.hasEmptyResult {
            emptyState
        } else if viewStore.loadPortfoliosState.isLoadingOrLoaded {
            ScrollView {
                overview
            }
        }
    }

    @ViewBuilder
    private var overview: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: 80, maximum: .infinity)),
                GridItem(.flexible(minimum: 80, maximum: .infinity)),
            ],
            content: {
                Button(action: {
                    showingCreatePorfolioAlert = true
                }) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create new")
                        }
                        Rectangle()
                            .frame(height: 0)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .fireButtonStyle()
                .redacted(reason: viewStore.loadPortfoliosState.isLoading ? .placeholder : [])
                ForEach(viewStore.loadPortfoliosState.hasResult
                    ? viewStore.loadPortfoliosState.result!
                    : (0 ... 3).map { _ in InvestmentPortfolioEntity.placeholder() }
                ) { portfolio in
                    PortfolioGridItem(portfolio: portfolio) {
                        viewStore.send(.forward(.navigateToPortfolioPage(id: portfolio.id)))
                    }
                    .disabled(viewStore.loadPortfoliosState.isLoading)
                    .redacted(reason: viewStore.loadPortfoliosState.isLoading ? .placeholder : [])
                }
            }
        )
    }
}

extension BindingViewStore<InvestmentHomeReducer.State> {
    var viewState: InvestmentHomePage.ViewState {
        // swiftformat:disable redundantSelf
        InvestmentHomePage.ViewState(
            portfolioName: self.$portfolioName,
            createPortfolioState: self.createPortfolioState,
            loadPortfoliosState: self.loadPortfoliosState,
            portfolioList: self.portfolioList
        )
        // swiftformat:enable redundantSelf
    }
}
