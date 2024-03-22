import ComposableArchitecture
import Factory
import SwiftUI

@Reducer
public struct InvestmentTradeImportOptionsReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?

        let importOptions: IdentifiedArrayOf<ImportOption> = [
            ImportOption.connectWallet,
            ImportOption.connectExchange,
            ImportOption.connectBroker,
            ImportOption.manual,
            ImportOption.importCSV,
        ]

        public init() {}
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case forward(Forward)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum Forward {
            case selectImportMethod(String)
        }

        @CasePathable
        public enum Delegate {
            case delegate
        }
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            case let .forward(.selectImportMethod(id)):
                guard let option = state.importOptions[id: id] else { return .none }

                if option == ImportOption.manual {
                    state.destination = .addTransactionRoute(.init())
                } else {
                    state.destination = .underConstructionRoute
                }

                return .none
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

public extension InvestmentTradeImportOptionsReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case addTransactionRoute(AddPortfolioTransactionReducer.State)
            case underConstructionRoute
        }

        public enum Action {
            case addTransactionRoute(AddPortfolioTransactionReducer.Action)
            case underConstructionRoute
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.addTransactionRoute, action: \.addTransactionRoute) {
                resolve(\InvestmentFeatureContainer.addInvestmentTradeReducer)
            }
        }
    }
}

struct ImportOption: Identifiable, Equatable {
    var id: String {
        return name
    }

    let name: String
    let description: String
}

extension ImportOption {
    static let connectWallet = ImportOption(name: "Connect Wallet", description: "")
    static let connectExchange = ImportOption(name: "Connect Exchange Account", description: "")
    static let connectBroker = ImportOption(name: "Connect Broker Account", description: "")
    static let manual = ImportOption(name: "Recode trade manually", description: "")
    static let importCSV = ImportOption(name: "Import CSV", description: "")
}
