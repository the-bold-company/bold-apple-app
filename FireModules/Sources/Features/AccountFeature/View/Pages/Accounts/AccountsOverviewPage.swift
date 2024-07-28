import ComposableArchitecture
import CoreUI
import SwiftUI

public struct AccountsOverviewPage: View {
    @State private var isSlideOverPresented = false

    let store: StoreOf<AccountsOverviewFeature>

    public init(store: StoreOf<AccountsOverviewFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Color(hex: 0xF2F4F7)
            Button(action: {
                withAnimation {
                    isSlideOverPresented.toggle()
                }
            }) {
                Text("Toggle Slide Over")
            }
        }
        .navigationTitle("Tài khoản")
        .toolbar {
            toolbarView
        }
        .slideOver(isPresented: $isSlideOverPresented) {
            AccountViewPage(
                store: store.scope(
                    state: \.createAccount,
                    action: \._local.createAccount
                )
            )
        }

//        .toolbarBackground(.red, for: .windowToolbar)
//        .toolbarBackground(.visible, for: .windowToolbar)
//        .toolbarColorScheme(.dark, for: .windowToolbar)
//        .toolbarBackground(.white, for: .windowToolbar)
    }

    @ToolbarContentBuilder
    private var toolbarView: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Menu("TK ngân hàng / Tiền mặt") {
                    Button("Nhập tay") { withAnimation { isSlideOverPresented = true } }
                    Button("Nhập tự động từ email") { /* self.day = "Tuesday" */ }
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

#Preview {
    MenuSideBarWrapper(
        featureOneBuilder: {
            AccountsOverviewPage(
                store: Store(initialState: .init()) {
                    AccountsOverviewFeature()
                }
            )
        }
    )
    .frame(minWidth: 800)
    .preferredColorScheme(.light)
}
