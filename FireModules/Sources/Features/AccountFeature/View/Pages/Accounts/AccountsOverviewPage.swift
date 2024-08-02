import CasePaths
import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct AccountsOverviewPage: View {
    @State private var isSlideOverPresented = false

    struct ViewState: Equatable {
        var getAccountsStatus: LoadingProgress<[AccountAPIResponse], GetAccountListFailure>
    }

    let store: StoreOf<AccountsOverviewFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, AccountsOverviewFeature.Action>

    public init(store: StoreOf<AccountsOverviewFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        Expanded {
            TwoThirdLayout(spacing: 24) {
                accountList
                accountOverview
            }
            .padding(.horizontal, 24)

            GeometryReader { geometry in
                EmptyView()
                    .sheet(store: store.scope(state: \.$destination.createAccount, action: \.destination.createAccount)) {
                        AccountViewPage(store: $0)
                            .frame(width: max(geometry.size.width * 0.4, 400), height: max(geometry.size.height * 0.6, 700))
                    }
            }
        }
        .navigationTitle("Tài khoản")
        .toolbar {
            toolbarView
        }
        .task {
            viewStore.send(.view(.onAppear))
        }
    }

    @ViewBuilder
    private var accountList: some View {
        Expanded {
            IfCaseLet(
                enum: viewStore.getAccountsStatus,
                casePath: \.loaded
            ) { result in
                switch result {
                case let .success(accs):
                    List {
                        Spacing(height: .size24)
                            .listRowSeparator(.hidden)
                            .listSectionSeparator(.hidden)

                        Section {
                            LazyVStack {
                                ForEach(accs, id: \.id) { item in
                                    AccountOverviewItem(account: item)
                                }
                                .listRowBackground(Color.white)
                                .listRowSeparator(.hidden)
                            }
                            .listRowInsets(.horizontal(-8))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                            )
                            .listRowSeparator(.hidden)
                            //                            .padding(.horizontal, 0)
                        } header: {
                            Text("TÀI KHOẢN NGÂN HÀNG / TIỀN MẶT")
                        }
                        .listSectionSeparator(.hidden)

//                        Section{
//                            accounts
//                                .listRowBackground(Color.white)
//                            //                            .listRowSeparator(.hidden, edges: .bottom)
//                                .alignmentGuide(.listRowSeparatorTrailing) { d in
//                                    d[.trailing]
//                                }
//                        } header: {
//                            Text("TÍN DỤNG")
//                        }
//                        .listSectionSeparator(.hidden)
//
//                        Section {
//                            accounts
//                                .listRowSeparator(.hidden)
//                        } header: {
//                            Text("TÍN DỤNG")
//                        }
//                        .listSectionSeparator(.hidden)
//                        .padding()
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .scrollIndicators(.never, axes: .vertical)
                    //                .padding(.vertical, 24)
                    .refreshable {
                        //                     await store.loadStats()
                    }
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }
//        orElse: {
//                List {
//                    Text("There's nothing here")
//                }
//            }
        }
    }

    @ViewBuilder
    private var accountOverview: some View {
        List {
            Text("Tổng quan")
                .font(.headline)
                .padding(.leading)

            HStack {
                VStack(alignment: .leading) {
                    Text("TÀI SẢN")
                    HStack {
                        Text("98,290,000 ₫")
                        Text("2% Tiền lẻ trong ví")
                        Text("98% Thẻ Timo - 1253")
                    }
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("NỢ")
                    HStack {
                        Text("-10,000,000 ₫")
                        Text("100% Thẻ VPBank Shopee - 2028")
                    }
                }
            }
//                    .padding(.horizontal)
        }
    }

    @ToolbarContentBuilder
    private var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Menu("TK ngân hàng / Tiền mặt") {
                    Button("Nhập tay") { withAnimation { isSlideOverPresented = true } }
                    Button("Nhập tự động từ email") { store.send(.view(.createAccountManuallyButtonTapped)) }
                    Button("Tải lên CSV") { /* self.day = "Wednesday" */ }
                }

                Color.clear.frame(width: 1, height: 1)

                Menu("Tài khoản tín dụng") {
                    Button("Nhập tay") { /* self.day = "Monday" */ }
                    Button("Nhập tự động từ email") { /* self.day = "Tuesday" */ }
                    Button("Tải lên CSV") { /* self.day = "Wednesday" */ }
                }
            } label: {
                Label("Tạo tài khoản", systemImage: "creditcard")
                    .labelStyle(_SideBarLabelStyle())
            }
            .menuStyle(MyMenuStyle())
            .foregroundColor(.white)
        }
    }

    struct MyMenuStyle: MenuStyle {
        func makeBody(configuration: Configuration) -> some View {
            Menu(configuration)
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .foregroundStyle(.blue)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.coreui.brightGreen)
                )
                .menuStyle(BorderlessButtonMenuStyle())
                .menuIndicator(.hidden)
        }
    }
}

extension BindingViewStore<AccountsOverviewFeature.State> {
    var viewState: AccountsOverviewPage.ViewState {
        // swiftformat:disable redundantSelf
        .init(
            getAccountsStatus: self.getAccountsStatus
        )
        // swiftformat:enable redundantSelf
    }
}

private struct _SideBarLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.icon
                .foregroundColor(.white)

            configuration.title
                .lineLimit(1)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct AccountOverviewItem: View {
    let account: AccountAPIResponse

    var body: some View {
        HStack {
            Image(systemName: "banknote")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .padding(12)
                .background {
                    Circle().fill(Color(hex: 0xF3F4F6))
                }

            Spacing(size: .size16)
            Text(account.name).typography(.bodySmall)
            Spacing(size: .size8)
            Button {
                //
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 12, height: 12)
                    .padding(4)
                    .background {
                        Circle().fill(Color(hex: 0xF3F4F6))
                    }
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()

            Spacer()
                .frame(width: 80, height: 56)
                .background(Color.blue)

            Spacer()

            VStack(alignment: .trailing) {
                Text("50,000 ₫").typography(.bodySmallMedium)
                Spacing(size: .size12)
                Text("▲0.04%")
                    .foregroundColor(Color.coreui.matureGreen)
                    .typography(.bodySmallMedium)
            }
        }
        .padding(.symetric(horizontal: 24, vertical: 20))
    }
}

// #Preview {
//    BankOverviewItem()
//        .padding()
// }

private let ACCESS_TOKEN = "eyJraWQiOiJQcVFzbE9vSmFZRVd5dno2YlwvbnV0Y0dMakZYcDBPS3ppMlcyb2NBOVdKdz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI2OTRhNTU0Yy1jMDkxLTcwNmEtZDlhYS1mNmQzODk5MDdlZmIiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuYXAtc291dGhlYXN0LTEuYW1hem9uYXdzLmNvbVwvYXAtc291dGhlYXN0LTFfT01mSmdpSVE4IiwiY2xpZW50X2lkIjoiNWpqbnFoY2N0ZWFhdG4xYnUwbnRtaXFma3UiLCJvcmlnaW5fanRpIjoiZWNlMmQ4ZGItODU0Mi00NDQzLWFhODMtM2E2YzU0NjA4MTdiIiwiZXZlbnRfaWQiOiI2NWI1YzlmOC1mMzdiLTRmYWQtYmQ0OC1jNWZhZjdmNzRjMzAiLCJ0b2tlbl91c2UiOiJhY2Nlc3MiLCJzY29wZSI6ImF3cy5jb2duaXRvLnNpZ25pbi51c2VyLmFkbWluIiwiYXV0aF90aW1lIjoxNzIyNDI2NjQ0LCJleHAiOjE3MjI0MzAyNDQsImlhdCI6MTcyMjQyNjY0NCwianRpIjoiOWQzNjRjMTEtYzUzMC00NWMwLWJkNWUtMTgwZmJkOTE5OTcwIiwidXNlcm5hbWUiOiI2OTRhNTU0Yy1jMDkxLTcwNmEtZDlhYS1mNmQzODk5MDdlZmIifQ.aAOHHC61w0sjWZp9QrzBJwxYztJ89bPDjp57TA1NzaUw4gm4BtbB1oGig3y3IZd6EwYg0OqlUzUj5_BhkvF1F6abSlZ3WzIn5r1wO6WgBdHauz8jQeeziuB6LXuHqEO_scUwkc-xlqqIJBuMWpuRpbkAPSlYfBiZ8WMmyIGbsPaVmimu2l_n0ya9rhYt_e_9i9Vqml0B9Up-qZKSkmeiaSZW5ldhhuhiob7tLfPYjHMqt6Dvhfw7i0rTmKa8vZqQDUg-Mi04pXDTyCSBK9bhEpDR-N1lYjZ6U70PjTY0Gw4O6iBp4uBwmKN-h7d-tmhAwhBtCrdNG8ipMnlrE6f8Mw"

#Preview {
    MenuSideBarWrapper(
        featureOneBuilder: {
            AccountsOverviewPage(
                //                store: Store(initialState: .init()) {
//                    AccountsOverviewFeature()
//                }
                store: Store(
                    initialState: .init(),
                    reducer: {
                        AccountsOverviewFeature()
                    },
                    withDependencies: {
//                        $0.context = .live
                        $0.keychainService.getAccessToken = { .success(ACCESS_TOKEN) }
                    }
                )
            )
        }
    )
    .frame(minWidth: 800)
    .preferredColorScheme(.light)
}

// struct ForEachIfLet<Data, Content, OtherwiseContent>: View where Content: View, OtherwiseContent: View {
//
//    @ViewBuilder var content: (Data) -> Content
//
//
// }
