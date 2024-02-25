import AutomaticSettings
import Inject
import SharedModels
// Generated using Sourcery 2.1.4 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import SwiftUI

extension DevSettingsView {
    // MARK: - Views

    struct CredentialsView<HeaderView: View, FooterView: View>: View, AutomaticSettingsViewDSL {
        typealias ViewModel = AutomaticSettingsViewModel<DevSettings, DevSettingsExternalData>

        @ObserveInjection var iO

        @ObservedObject
        var viewModel: ViewModel

        var headerView: HeaderView
        var footerView: FooterView

        init(viewModel: ViewModel, headerView: HeaderView, footerView: FooterView) {
            self.viewModel = viewModel
            self.headerView = headerView
            self.footerView = footerView
        }

        init(viewModel: ViewModel) where HeaderView == EmptyView, FooterView == EmptyView {
            self.viewModel = viewModel
            self.headerView = EmptyView()
            self.footerView = EmptyView()
        }

        init(viewModel: ViewModel, headerView: HeaderView) where FooterView == EmptyView {
            self.viewModel = viewModel
            self.headerView = headerView
            self.footerView = EmptyView()
        }

        init(viewModel: ViewModel, footerView: FooterView) where HeaderView == EmptyView {
            self.viewModel = viewModel
            self.headerView = EmptyView()
            self.footerView = footerView
        }

        var body: some View {
            Group {
                headerView
                settings()
                footerView
            }
            .enableInjection()
        }

        /// `Group` containing all Credentials views
        func settings() -> some View {
            Section {
                Group {
                    setting(
                        "username",
                        keyPath: \.credentials.username,
                        requiresRestart: false,
                        sideEffect: nil,
                        uniqueIdentifier: "\\.credentials.username"
                    )
                    setting(
                        "password",
                        keyPath: \.credentials.password,
                        requiresRestart: false,
                        sideEffect: nil,
                        uniqueIdentifier: "\\.credentials.password"
                    )
                }
            }
        }
    }

    struct ThemeView<HeaderView: View, FooterView: View>: View, AutomaticSettingsViewDSL {
        typealias ViewModel = AutomaticSettingsViewModel<DevSettings, DevSettingsExternalData>

        @ObserveInjection var iO

        @ObservedObject
        var viewModel: ViewModel

        var headerView: HeaderView
        var footerView: FooterView

        init(viewModel: ViewModel, headerView: HeaderView, footerView: FooterView) {
            self.viewModel = viewModel
            self.headerView = headerView
            self.footerView = footerView
        }

        init(viewModel: ViewModel) where HeaderView == EmptyView, FooterView == EmptyView {
            self.viewModel = viewModel
            self.headerView = EmptyView()
            self.footerView = EmptyView()
        }

        init(viewModel: ViewModel, headerView: HeaderView) where FooterView == EmptyView {
            self.viewModel = viewModel
            self.headerView = headerView
            self.footerView = EmptyView()
        }

        init(viewModel: ViewModel, footerView: FooterView) where HeaderView == EmptyView {
            self.viewModel = viewModel
            self.headerView = EmptyView()
            self.footerView = footerView
        }

        var body: some View {
            Group {
                headerView
                settings()
                footerView
            }
            .enableInjection()
        }

        /// `Group` containing all Theme views
        func settings() -> some View {
            Section {
                Group {
                    setting(
                        "color",
                        keyPath: \.theme.color,
                        requiresRestart: false,
                        sideEffect: nil,
                        uniqueIdentifier: "\\.theme.color"
                    )
                }
            }
        }
    }

    // MARK: -

    /// All generated section links:
    // Group {
    // credentialsLink()
    // themeLink()
    // }

    // MARK: - Top Level Link wrappers

    func credentialsLink(
        label: String = "Credentials",
        @ViewBuilder headerView: @escaping () -> some View,
        @ViewBuilder footerView: @escaping () -> some View
    ) -> some View {
        NavigationLink(
            label.automaticSettingsTitleCase,
            destination:
            Form {
                CredentialsView(viewModel: viewModel, headerView: InjectionWrapper { headerView() }, footerView: InjectionWrapper { footerView() })
            }
            // .navigationBarTitle("Credentials".automaticSettingsTitleCase)
        )
    }

    func credentialsLink(
        label: String = "Credentials",
        @ViewBuilder headerView: @escaping () -> some View
    ) -> some View {
        NavigationLink(
            label.automaticSettingsTitleCase,
            destination:
            Form {
                CredentialsView(viewModel: viewModel, headerView: InjectionWrapper { headerView() })
            }
            // .navigationBarTitle("Credentials".automaticSettingsTitleCase)
        )
    }

    func credentialsLink(
        label: String = "Credentials",
        @ViewBuilder footerView: @escaping () -> some View
    ) -> some View {
        NavigationLink(
            label.automaticSettingsTitleCase,
            destination:
            Form {
                CredentialsView(viewModel: viewModel, footerView: footerView())
            }
            // .navigationBarTitle("Credentials".automaticSettingsTitleCase)
        )
    }

    func credentialsLink(
        label: String = "Credentials"
    ) -> some View {
        NavigationLink(
            label.automaticSettingsTitleCase,
            destination:
            Form {
                CredentialsView(viewModel: self.viewModel)
            }
            // .navigationBarTitle("Credentials".automaticSettingsTitleCase)
        )
    }

    func themeLink(
        label: String = "Theme",
        @ViewBuilder headerView: @escaping () -> some View,
        @ViewBuilder footerView: @escaping () -> some View
    ) -> some View {
        NavigationLink(
            label.automaticSettingsTitleCase,
            destination:
            Form {
                ThemeView(viewModel: viewModel, headerView: InjectionWrapper { headerView() }, footerView: InjectionWrapper { footerView() })
            }
            // .navigationBarTitle("Theme".automaticSettingsTitleCase)
        )
    }

    func themeLink(
        label: String = "Theme",
        @ViewBuilder headerView: @escaping () -> some View
    ) -> some View {
        NavigationLink(
            label.automaticSettingsTitleCase,
            destination:
            Form {
                ThemeView(viewModel: viewModel, headerView: InjectionWrapper { headerView() })
            }
            // .navigationBarTitle("Theme".automaticSettingsTitleCase)
        )
    }

    func themeLink(
        label: String = "Theme",
        @ViewBuilder footerView: @escaping () -> some View
    ) -> some View {
        NavigationLink(
            label.automaticSettingsTitleCase,
            destination:
            Form {
                ThemeView(viewModel: viewModel, footerView: footerView())
            }
            // .navigationBarTitle("Theme".automaticSettingsTitleCase)
        )
    }

    func themeLink(
        label: String = "Theme"
    ) -> some View {
        NavigationLink(
            label.automaticSettingsTitleCase,
            destination:
            Form {
                ThemeView(viewModel: self.viewModel)
            }
            // .navigationBarTitle("Theme".automaticSettingsTitleCase)
        )
    }
}

/// Creates a view that supports injecting dynamic header / footer
struct InjectionWrapper<Content: View>: View {
    @ObserveInjection var iO
    var content: () -> Content
    var body: some View {
        content()
            .enableInjection()
    }
}

// swiftlint:enable all
