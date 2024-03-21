import ComposableArchitecture
import CoreUI
import SwiftUI

public struct AddPortfolioTransactionPage: View {
    @ObserveInjection private var iO

    private let store: StoreOf<AddPortfolioTransactionReducer>

    public init(store: StoreOf<AddPortfolioTransactionReducer>) {
        self.store = store
    }

    @State var amount: String = ""
    @State var notes: String = ""

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { _ in
            VStack {
                availableCashBalance
                transactionTypeSelection
                inputs
            }
        }
        .enableInjection()
    }

    @ViewBuilder
    private var transactionTypeSelection: some View {
        HStack(alignment: .center, spacing: 12) {
            Button {} label: {
                Text("Log in")
                    .frame(maxWidth: .infinity)
            }
            .fireButtonStyle(type: .secondary(shape: .roundedCorner))

            Button {} label: {
                Text("Sign up")
                    .frame(maxWidth: .infinity)
            }
            .fireButtonStyle(type: .secondary(shape: .roundedCorner))
        }
        .padding(.horizontal(16))
//        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var availableCashBalance: some View {
        VStack {
            Text("Available cash")
            Text("Total balance: $29,549")
        }
    }

    @ViewBuilder var inputs: some View {
        List {
            Button {
                //
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Currency")
                            .typography(.titleSmall)
                            .foregroundColor(.coreui.forestGreen)
                        Spacing(size: .size4)
                        Text("USD")
                            .typography(.bodyLargeBold)
                            .foregroundColor(.coreui.forestGreen)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.coreui.forestGreen)
                }
                .padding(.vertical(4))
            }
            Button {
                //
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Date & time")
                            .typography(.titleSmall)
                            .foregroundColor(.coreui.forestGreen)
                        Spacing(size: .size4)
                        Text("Mon 18 Mar, 2024, 13:00")
                            .typography(.bodyLargeBold)
                            .foregroundColor(.coreui.forestGreen)
                    }
                }
                .padding(.vertical(4))
            }
            TextField("Amount", text: $amount)
            TextField("Notes", text: $notes)
        }
    }
}

// extension String: Identifiable {
//    public var id: String {
//        return self
//    }
// }
