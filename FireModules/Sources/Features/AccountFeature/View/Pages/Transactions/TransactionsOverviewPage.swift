import ComposableArchitecture
import CoreUI
import SwiftUI

public struct TransactionsOverviewPage: View {
    struct ViewState: Equatable {
        var isLoadingTransactions: Bool
    }

    let store: StoreOf<TransactionsOverviewFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, TransactionsOverviewFeature.Action>

    public init(store: StoreOf<TransactionsOverviewFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        Expanded(color: Color(hex: 0xF2F4F7)) {
            navigationLinks
            Expanded {
                VStack {
                    HStack {
                        Text("Lịch sử giao dịch").typography(.bodyDefaultBold)
                        Spacer()
                        MacButton.tertiary {
                            //
                        } label: {
                            Label("Nhập tự động", systemImage: "bolt.fill")
//                            Text("Nhập tự động")
                        }

                        Divider().frame(height: 32)
                            .padding(.horizontal, 12)

                        MacButton.tertiary {} label: {
                            Image(systemName: "plus")
                        }
                    }

                    Divider()
                    Spacing(size: .size12)

                    Expanded(color: Color(hex: 0xF2F4F7)) {
                        ZStack {
                            VStack(spacing: 16) {
                                Image(systemName: "list.bullet.clipboard")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)

                                Text("Chưa có giao dịch nào").typography(.bodyDefaultBold)

                                MacButton.black {
                                    viewStore.send(.view(.addTransactionButtonTapped))
                                } label: {
                                    Label("Nhập giao dịch", systemImage: "plus")
                                }
                            }
                        }
                    }
                    .cornerRadius(8, antialiased: true)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(.white)
                .cornerRadius(8, antialiased: true)
            }
            .padding(24)
        }
        .navigationTitle("Tài khoản")
    }

    @ViewBuilder
    private var navigationLinks: some View {
        GeometryReader { geometry in
            VStack {}
                .hidden()
                .accessibilityHidden(true)
                .sheet(
                    store: store.scope(
                        state: \.$destination.createNewTransaction,
                        action: \.destination.createNewTransaction
                    )
                ) {
                    TransactionCreationPage(store: $0)
                        .frame(
                            width: max(geometry.size.width * 0.4, 400),
                            height: max(geometry.size.height * 0.6, 700)
                        )
                }
        }
    }
}

extension BindingViewStore<TransactionsOverviewFeature.State> {
    var viewState: TransactionsOverviewPage.ViewState {
        // swiftformat:disable redundantSelf
        .init(
            isLoadingTransactions: false
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    MenuSideBarWrapper(
        featureOneBuilder: {
            TransactionsOverviewPage(
                store: Store(initialState: .init()) {
                    TransactionsOverviewFeature()
                }
            )
        }
    )
    .preferredColorScheme(.light)
}
