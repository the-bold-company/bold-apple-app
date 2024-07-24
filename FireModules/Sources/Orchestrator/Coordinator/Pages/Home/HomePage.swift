#if os(macOS)
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

    @State var path = NavigationPath()
//    @State var selection: Int? = nil

    public var body: some View {
        NavigationSplitView {
            List(Item.allCases, id: \.self) { item in
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
                        .labelStyle(MyLabelStyle(selected: item == selection))
                }
                .buttonStyle(MoukaSideBarButtonStyle(selected: item == selection))
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
            ) { accounts(store: $0) }
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.transactions,
                    action: \.destination.transactions
                )
            ) { transactions(store: $0) }
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.categories,
                    action: \.destination.categories
                )
            ) { categories(store: $0) }
        }
        detail: { Text("Select a feature") }
//        .background(Color.white)
//        .introspect(.navigationSplitView, on: .macOS(.v13, .v14, .v15)) {
        ////                print(type(of: $0 as NSSplitView))  NSSplitView
        ////            $0.leftPane.wantsLayer = true
        ////            $0.backgroundColor = NSColor.red.cgColor
        ////            $0.viewControllers[0].view.backgroundColor = NSColor.red.cgColor
//            let backgroundView = NSView(frame: $0.bounds)
//            backgroundView.wantsLayer = true
//            backgroundView.layer?.backgroundColor = NSColor.red.cgColor
//
//                    // Add the background view to the split view
//            $0.addSubview(backgroundView, positioned: .below, relativeTo: $0.subviews.first)
//
//                    // Ensure the background view resizes with the split view
//            backgroundView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                backgroundView.topAnchor.constraint(equalTo: $0.topAnchor),
//                backgroundView.bottomAnchor.constraint(equalTo: $0.bottomAnchor),
//                backgroundView.leadingAnchor.constraint(equalTo: $0.leadingAnchor),
//                backgroundView.trailingAnchor.constraint(equalTo: $0.trailingAnchor)
//            ])
//        }
        .navigationSplitViewStyle(.balanced)
        .navigationBarBackButtonHidden(true)
//        .tint(Color(hex: 0xECFAE2))
    }
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

struct MyLabelStyle: LabelStyle {
    //   let textColor: Color
    let selected: Bool

    func makeBody(configuration: Configuration) -> some View {
//       Label(configuration)
//           .frame(width: .infinity, height: .infinity, alignment: .leading)
//           .foregroundColor(Color(hex: selected ? 0x4C8A1D : 0x1F2937))
        ////           .listRowBackground(selected ? Color(hex: 0xECFAE2) : .clear)
//           .background(selected ? Color(hex: 0xECFAE2) : .clear)
//           .background(
//               RoundedRectangle(cornerRadius: 8)
//                   .fill(selected ? Color(hex: 0xECFAE2) : .clear)
//           )
//           .padding(15)
//           .background(Capsule().fill(gradient))
//           .background(Capsule().stroke(Color.secondary, lineWidth: 1))
//           .font(.largeTitle)
        HStack(spacing: 8) {
            configuration.icon

//               .background(Circle().fill(color))

            configuration.title // .padding(.trailing, 10)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
//       .padding(.symetric(horizontal: 12, vertical: 8))
//       .frame(width: .infinity, alignment: .leading)
//       .foregroundColor(Color(hex: selected ? 0x4C8A1D : 0x1F2937))
//       .listRowBackground(selected ? Color(hex: 0xECFAE2) : .clear)
//       .tint(Color(hex: 0xECFAE2))
//       .background(selected ? Color(hex: 0xECFAE2) : .clear)
//       .padding(6)
//       .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
    }
}

public struct MoukaSideBarButtonStyle: ButtonStyle {
    public init(selected: Bool = false) {
        self.selected = selected
    }

    let selected: Bool

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.symetric(horizontal: 8, vertical: 8))
            .font(.custom(FontFamily.Inter.medium, size: 12))
            .foregroundColor(
                selected
                    ? Color(hex: 0x4C8A1D)
                    : Color(hex: 0x1F2937).opacity(configuration.isPressed ? 0.7 : 1)
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selected ? Color(hex: 0xECFAE2) : .clear)
            )
            .compositingGroup()
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
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
