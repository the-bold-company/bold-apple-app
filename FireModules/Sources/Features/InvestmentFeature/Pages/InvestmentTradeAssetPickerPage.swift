import ComposableArchitecture
import CoreUI
import SwiftUI

public struct InvestmentTradeAssetPickerPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        let assetTypes: IdentifiedArrayOf<AssetType>
    }

    let store: StoreOf<InvestmentTradeAssetPickerReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, InvestmentTradeAssetPickerReducer.Action>

    public init(store: StoreOf<InvestmentTradeAssetPickerReducer>) {
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
            Text("Which asset type would you like to add").typography(.titleScreen)
            assetOptions
        }
        .navigationBarHidden(true)
        .padding()
        .fullScreenCover(
            store: store.scope(
                state: \.$destination.underConstructionRoute,
                action: \.destination.underConstructionRoute
            )
        ) { _ in return UnderConstructionPage() }
        .navigationDestination(
            store: store.scope(
                state: \.$destination.stockSearchHomeRoute,
                action: \.destination.stockSearchHomeRoute
            )
        ) { StockSearchHomePage(store: $0) }
        .enableInjection()
    }

    @ViewBuilder
    private var assetOptions: some View {
        GeometryReader { _ in
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: 80, maximum: .infinity)),
                    GridItem(.flexible(minimum: 80, maximum: .infinity)),
                ],
                content: {
                    ForEach(viewStore.assetTypes) { asset in

                        Button(action: {
                            viewStore.send(.forward(.selectAssetType(asset)))
                        }) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(asset.rawValue)
                                Rectangle()
                                    .frame(height: 0)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .secondaryButtomCustomBorderStyle(
                            borderColor: .coreui.forestGreen,
                            backgroundColor: .coreui.brightGreen.opacity(0.5)
                        )
                    }

                    Button(action: {}) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("More type coming soon")
                                .typography(.titleSmall)
                            Rectangle()
                                .frame(height: 0)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .secondaryButtomCustomBorderStyle(
                        borderColor: .coreui.brightGreen.opacity(0.5),
                        backgroundColor: .coreui.brightGreen.opacity(0.5),
                        textColor: Color.gray
                    )
                }
            )
        }
    }
}

extension BindingViewStore<InvestmentTradeAssetPickerReducer.State> {
    var viewState: InvestmentTradeAssetPickerPage.ViewState {
        // swiftformat:disable redundantSelf
        InvestmentTradeAssetPickerPage.ViewState(
            assetTypes: self.assetTypes
        )
        // swiftformat:enable redundantSelf
    }
}
