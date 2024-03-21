import ComposableArchitecture
import CoreUI
import SwiftUI

public struct AddInvestmentTradeOptionsPage: View {
    @ObserveInjection private var iO

    private let store: StoreOf<AddInvestmentTradeOptionsReducer>

    public init(store: StoreOf<AddInvestmentTradeOptionsReducer>) {
        self.store = store
    }

    let mock: [String] = [
        "Manually",
        "Import CSV",
        "Link broker account",
    ]

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { _ in
            NavigationView {
                List(mock) { option in
                    Button {
//                        viewStore.send(.fundSelected(id: fund.id))
                    } label: {
                        HStack {
                            Text(option).typography(.bodyDefault)
                                .foregroundColor(.coreui.forestGreen)
                        }
                    }
                    .tag(Optional(option))
                }
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
