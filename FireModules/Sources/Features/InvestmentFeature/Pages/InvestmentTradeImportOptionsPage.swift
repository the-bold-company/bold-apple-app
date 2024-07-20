import ComposableArchitecture
import CoreUI
import SwiftUI

public struct InvestmentTradeImportOptionsPage: View {
    @ObserveInjection private var iO

    private let store: StoreOf<InvestmentTradeImportOptionsReducer>

    public init(store: StoreOf<InvestmentTradeImportOptionsReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack(alignment: .leading) {
                    FireNavBar(
                        trailing: {
                            DismissButton(image: {
                                Image(systemName: "xmark")
                            })
                        }
                    )

                    List(viewStore.importOptions) { option in
                        Button {
                            viewStore.send(.forward(.selectImportMethod(option.id)))
                        } label: {
                            HStack {
                                Text(option.name).typography(.bodyDefault)
                                    .foregroundColor(.coreui.forestGreen)
                            }
                        }
                    }
                    .listStyle(.inset)
                }
                .hideNavigationBar()
                .padding()
                #if os(iOS)
                    .fullScreenCover(
                        store: store.scope(
                            state: \.$destination.underConstructionRoute,
                            action: \.destination.underConstructionRoute
                        )
                    ) { _ in return UnderConstructionPage() }
                #endif
                    .navigationDestination(
                        store: store.scope(
                            state: \.$destination.assetPickerRoute,
                            action: \.destination.assetPickerRoute
                        )
                    ) { InvestmentTradeAssetPickerPage(store: $0) }
            }
        }
        .enableInjection()
    }
}

extension String: Identifiable {
    public var id: String {
        return self
    }
}
