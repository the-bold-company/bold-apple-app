import Authentication
import ComposableArchitecture
import CoreUI
@_exported import Inject
@_exported import Playbook
@_exported import PlaybookUI
import SwiftUI

public enum ScenarioCatalog: String {
    case home
    case coreui
    case authentication

    var kind: ScenarioKind {
        return ScenarioKind(stringLiteral: rawValue)
    }
}

public enum PlaybookBuilder {
    public static func build() -> Playbook {
        let playbook = Playbook()

        playbook.addScenarios(catalog: .authentication) {
            Scenario("Landing Page", layout: .fill) {
                LandingPage(
                    store: Store(
                        initialState: .init(),
                        reducer: { LandingFeature() }
                    )
                )
            }
        }

        playbook.addScenarios(catalog: .authentication) {
            Scenario("Login", layout: .fill) {
                LoginPage()
            }
        }

        playbook.addScenarios(catalog: .coreui) {
            Scenario("FireTextView", layout: .fill) {
                Group {
                    TextFieldWrapper(title: "TextView", type: .normal)
                    TextFieldWrapper(title: "Secure TextView", type: .secure)
                }
                .padding()
            }
        }

        playbook.addScenarios(catalog: .coreui) {
            Scenario("LoadingOverlay", layout: .fill) {
                LoadingOverlay(loading: true) {
                    Image(systemName: "globe")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                        .frame(width: 200, height: 200)
                }
            }
        }

        return playbook
    }
}

private extension Playbook {
    /// Adds a set of scenarios passed by function builder.
    ///
    /// - Parameters:
    ///   - catalog: A catalog identifier that groups a set of scenarios.
    ///   - scenarios: A function builder that create a set of scenarios.
    ///
    /// - Returns: A instance of `self`.
    @discardableResult
    func addScenarios(
        catalog: ScenarioCatalog,
        @ScenariosBuilder _ scenarios: () -> some ScenariosBuildable
    ) -> Self {
        return addScenarios(of: catalog.kind, scenarios)
    }
}

// ContentView for the Playbook scenario
struct TextFieldWrapper: View {
    enum TextFieldType {
        case normal
        case secure
    }

    @State private var text = ""
    let title: String
    let type: TextFieldType

    init(title: String, type: TextFieldType) {
        self.title = title
        self.type = type
    }

    var body: some View {
        switch type {
        case .normal:
            FireTextField(title: title, text: $text)
        case .secure:
            FireSecureTextField(title: title, text: $text)
        }
    }
}
