#if os(macOS)
import AccountFeature
import ComposableArchitecture
import CoreUI
import SwiftUI
import TCAExtensions

public struct HomePage: View {
    struct ViewState: Equatable {
        var selected: String
    }

    let store: StoreOf<HomeFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, HomeFeature.Action>
    @State private var selection: Item? = .overview

    public init(store: StoreOf<HomeFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    enum Item: String, Identifiable, CaseIterable {
        case overview = "Overview"
        case reports = "Reports"
        case accounts = "Accounts"
        case transactions = "Transactions"
        case categories = "Categories"

        var id: String { rawValue }
        var image: String {
            switch self {
            case .overview: "house"
            case .reports: "chart.bar"
            case .accounts: "creditcard"
            case .transactions: "square.stack.3d.up.fill"
            case .categories: "tag"
            }
        }
    }

    public var body: some View {
        NavigationSplitView {
            List {
                MacButton.bordered {
                    viewStore.send(.view(.manualCreditAccountCreationTapped))
                } label: {
                    Label("Giao dịch", systemImage: "plus")
                }
                .frame(maxWidth: .infinity)

                Divider()

                ForEach(Item.allCases, id: \.self) { item in
                    Button {
                        selection = item

                        switch item {
                        case .overview:
                            viewStore.send(.view(.goToOverview))
                        case .reports:
                            viewStore.send(.view(.goToReports))
                        case .accounts:
                            viewStore.send(.view(.goToAccounts))
                        case .transactions:
                            viewStore.send(.view(.goToTransactions))
                        case .categories:
                            viewStore.send(.view(.goToCategories))
                        }
                    } label: {
                        Label(item.rawValue, systemImage: item.image)
                            .labelStyle(SideBarLabelStyle())
                    }
                    .buttonStyle(SideBarButtonStyle(selected: item == selection))
                }

                Divider()

                HStack(alignment: .center) {
                    Info(explaination: "Explaination goes here") {
                        Text("Tài khoản")
                            .font(.custom(FontFamily.Inter.semiBold, size: 12))
                            .foregroundColor(Color(hex: 0x9CA3AF))
                    }

                    Spacer()

                    Menu {
                        Menu("TK ngân hàng / Tiền mặt") {
                            Button("Nhập tay") {}
                            Button("Nhập tự động từ email") {}
                            Button("Tải lên CSV") {}
                        }

                        Color.clear.frame(width: 1, height: 1)

                        Menu("Tài khoản tín dụng") {
                            Button("Nhập tay") {}
                            Button("Nhập tự động từ email") {}
                            Button("Tải lên CSV") {}
                        }
                    } label: {
                        Label("Thêm", systemImage: "plus")
                    }
                    .macButtonStyle(.tertiary)
                }
            }
            .background(Color.white)
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.overview,
                    action: \.destination.overview
                )
            ) { overview(store: $0) }
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.reports,
                    action: \.destination.reports
                )
            ) { reports(store: $0) }
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.accounts,
                    action: \.destination.accounts
                )
            ) { AccountsOverviewPage(store: $0) }
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.transactions,
                    action: \.destination.transactions
                )
            ) { TransactionsOverviewPage(store: $0) }
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.categories,
                    action: \.destination.categories
                )
            ) { categories(store: $0) }
        } detail: {
            Text("Select a feature")
        }
        .navigationSplitViewStyle(.balanced)
        .navigationBarBackButtonHidden(true)
        //            .sheet(
        //                store: store.scope(
        //                    state: \.$destination.createBankAccount,
        //                    action: \.destination.createBankAccount
        //                )
        //            ) {
        //                AccountViewPage(store: $0)
        //                    .frame(
        //                        width: 400, // max(geometry.size.width * 0.4, 400),
        //                        height: 700 // max(geometry.size.height * 0.6, 700)
        //                    )
        //            }
        .sheet(
            store: store.scope(
                state: \.$destination.createCreditAccount,
                action: \.destination.createCreditAccount
            )
        ) {
            CreditAccountDetailPage(store: $0)
                .frame(
                    width: max((NSScreen.main?.frame.width ?? 1000) * 0.4, 400),
                    height: max((NSScreen.main?.frame.height ?? 1000) * 0.6, 700)
                )
        }
    }

//    @ViewBuilder
//    private var modalNavigationLinks: some View {
//        GeometryReader { geometry in
//            VStack {}
//                .hidden()
//                .accessibilityHidden(true)
//                .sheet(
//                    store: store.scope(
//                        state: \.$modalDestination.createBankAccount,
//                        action: \.modalDestination.createBankAccount
//                    )
//                ) {
//                    AccountViewPage(store: $0)
//                        .frame(
//                            width: max(geometry.size.width * 0.4, 400),
//                            height: max(geometry.size.height * 0.6, 700)
//                        )
//                }
//                .sheet(
//                    store: store.scope(
//                        state: \.$modalDestination.createCreditAccount,
//                        action: \.modalDestination.createCreditAccount
//                    )
//                ) {
//                    CreditAccountDetailPage(store: $0)
//                        .frame(
//                            width: max(geometry.size.width * 0.4, 400),
//                            height: max(geometry.size.height * 0.6, 700)
//                        )
//                }
//        }
//    }
}

extension BindingViewStore<HomeFeature.State> {
    var viewState: HomePage.ViewState {
        // swiftformat:disable redundantSelf
        HomePage.ViewState(
            selected: self.something
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    HomePage(
        store: Store(initialState: .init()) { HomeFeature() }
    )
    .frame(minWidth: 600, minHeight: 500)
    .preferredColorScheme(.light)
}

#endif

public struct Info<Label>: View where Label: View {
    private let label: () -> Label
    private let explaination: String
    @State private var popoverPresented = false

    public init(
        explaination: String,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.label = label
        self.explaination = explaination
    }

    public var body: some View {
        HStack(spacing: 4) {
            label()
            Button {
                popoverPresented = true
            } label: {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(Color(hex: 0xD1D5DB))
            }
            .buttonStyle(PlainButtonStyle())
            .popover(
                isPresented: $popoverPresented,
                attachmentAnchor: .rect(.bounds), arrowEdge: .trailing
            ) {
                ZStack {
                    // Apple is stupid enough to make it so hard to change the popover background. Here's the workaround -> https://stackoverflow.com/a/62489622/6254518
                    Color(hex: 0x111827).scaleEffect(2.5)
                    Text(explaination).typography(.bodySmall)
                }
                .foregroundColor(.white)
                .padding(8)
                .frame(width: max((NSScreen.main?.frame.width ?? 1200) / 12, 100))
            }
        }
    }
}
