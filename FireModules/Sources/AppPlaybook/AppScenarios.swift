import Authentication
@_exported import Inject
@_exported import Playbook
@_exported import PlaybookUI

public enum ScenarioCatalog: String {
    case home

    var kind: ScenarioKind {
        return ScenarioKind(stringLiteral: rawValue)
    }
}

public enum PlaybookBuilder {
    public static func build() -> Playbook {
        let playbook = Playbook()

        playbook.addScenarios(catalog: .home) {
            Scenario("Landing Page", layout: .fill) {
                LandingPage()
            }
        }

        playbook.addScenarios(catalog: .home) {
            Scenario("Login", layout: .fill) {
                LoginPage()
            }
        }

        playbook.addScenarios(catalog: .home) {
            Scenario("Login 3", layout: .fill) {
                LoginPage()
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
