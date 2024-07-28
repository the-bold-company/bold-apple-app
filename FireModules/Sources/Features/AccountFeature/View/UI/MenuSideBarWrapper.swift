#if os(macOS)
import ComposableArchitecture
import CoreUI
import SwiftUI

@Reducer
public struct MenuSideBarFeature {
    @Reducer(state: .equatable)
    public enum Destination: String, CaseIterable {
        case featureOne = "Feature One"
        case featureTwo = "Feature Two"
        case featureThree = "Feature Three"
        case featureFour = "Feature Four"
        case featureFive = "Feature Five"

        var image: String {
            switch self {
            case .featureOne: "house"
            case .featureTwo: "chart.bar"
            case .featureThree: "creditcard"
            case .featureFour: "square.stack.3d.up.fill"
            case .featureFive: "tag"
            }
        }
    }

    public struct State: Equatable {
        @PresentationState var destination: Destination.State? = .featureOne
        public init() {}
    }

    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        case view(ViewAction)

        @CasePathable
        public enum ViewAction {
            case goToFeatureOne
            case goToFeatureTwo
            case goToFeatureThree
            case goToFeatureFour
            case goToFeatureFive
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .goToFeatureOne:
            state.destination = .featureOne
        case .goToFeatureTwo:
            state.destination = .featureTwo
        case .goToFeatureThree:
            state.destination = .featureThree
        case .goToFeatureFour:
            state.destination = .featureFour
        case .goToFeatureFive:
            state.destination = .featureFive
        }
        return .none
    }
}

public struct MenuSideBarWrapper<Content1, Content2, Content3, Content4, Content5>: View
    where Content1: View, Content2: View, Content3: View, Content4: View, Content5: View
{
    private let store: StoreOf<MenuSideBarFeature>
    @State private var selection: MenuSideBarFeature.Destination? = .featureOne

    @ViewBuilder private var featureOneBuilder: () -> Content1
    @ViewBuilder private var featureTwoBuilder: () -> Content2
    @ViewBuilder private var featureThreeBuilder: () -> Content3
    @ViewBuilder private var featureFourBuilder: () -> Content4
    @ViewBuilder private var featureFiveBuilder: () -> Content5

    public init(
        @ViewBuilder featureOneBuilder: @escaping () -> Content1 = { Text("Feature 1️⃣") },
        @ViewBuilder featureTwoBuilder: @escaping () -> Content2 = { Text("Feature 2️⃣") },
        @ViewBuilder featureThreeBuilder: @escaping () -> Content3 = { Text("Feature 3️⃣") },
        @ViewBuilder featureFourBuilder: @escaping () -> Content4 = { Text("Feature 4️⃣") },
        @ViewBuilder featureFiveBuilder: @escaping () -> Content5 = { Text("Feature 5️⃣") }
    ) {
        self.store = Store(initialState: .init()) { MenuSideBarFeature() }
        self.featureOneBuilder = featureOneBuilder
        self.featureTwoBuilder = featureTwoBuilder
        self.featureThreeBuilder = featureThreeBuilder
        self.featureFourBuilder = featureFourBuilder
        self.featureFiveBuilder = featureFiveBuilder
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationSplitView {
                List(MenuSideBarFeature.Destination.allCases, id: \.self) { item in
                    Button {
                        selection = item

                        switch item {
                        case .featureOne:
                            viewStore.send(.view(.goToFeatureOne))
                        case .featureTwo:
                            viewStore.send(.view(.goToFeatureTwo))
                        case .featureThree:
                            viewStore.send(.view(.goToFeatureThree))
                        case .featureFour:
                            viewStore.send(.view(.goToFeatureFour))
                        case .featureFive:
                            viewStore.send(.view(.goToFeatureFive))
                        }
                    } label: {
                        Label(item.rawValue, systemImage: item.image)
                            .labelStyle(_SideBarLabelStyle())
                    }
                    .buttonStyle(_SideBarButtonStyle(selected: item == selection))
                }
                .background(Color.white)
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.featureOne,
                        action: \.destination.featureOne
                    )
                ) { _ in featureOneBuilder() }
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.featureTwo,
                        action: \.destination.featureTwo
                    )
                ) { _ in featureTwoBuilder() }
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.featureThree,
                        action: \.destination.featureThree
                    )
                ) { _ in featureThreeBuilder() }
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.featureFour,
                        action: \.destination.featureFour
                    )
                ) { _ in featureFourBuilder() }
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.featureFive,
                        action: \.destination.featureFive
                    )
                ) { _ in featureFiveBuilder() }
            } detail: {
                Text("Select a feature")
            }
            .navigationSplitViewStyle(.balanced)
            .navigationBarBackButtonHidden(true)
        }
    }
}

// extension BindingViewStore<HomeFeature.State> {
//    var viewState: HomePage.ViewState {
//        // swiftformat:disable redundantSelf
//        HomePage.ViewState(
//            selected: self.something
//        )
//        // swiftformat:enable redundantSelf
//    }
// }

private struct _SideBarButtonStyle: ButtonStyle {
    let selected: Bool

    init(selected: Bool = false) {
        self.selected = selected
    }

    func makeBody(configuration: Self.Configuration) -> some View {
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

private struct _SideBarLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.icon

            configuration.title
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    MenuSideBarWrapper()
        .frame(minWidth: 600, minHeight: 500)
        .preferredColorScheme(.light)
}

#endif
