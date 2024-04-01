import ComposableArchitecture
import CoreUI
import SwiftUI

struct CurrencyPickerPage: View {
    @ObserveInjection private var iO

    private let store: StoreOf<CurrencyPickerReducer>

    public init(store: StoreOf<CurrencyPickerReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                FireNavBar(
                    leading: { DismissButton() },
                    center: { Text("Change currency") }
                )
                List(viewStore.currencies) { currency in
                    Button {
                        viewStore.send(.selectCurrency(currency))
                    } label: {
                        HStack {
                            Text(currency.currencyCodeString)
                                .typography(.bodyDefault)
                                .foregroundColor(.coreui.forestGreen)
                            Spacer()
                            if currency == viewStore.currentlySelected {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarHidden(true)
            .padding()
        }
        .enableInjection()
    }
}
