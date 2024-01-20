//
//  DevSettingsView.swift
//
//
//  Created by Hien Tran on 19/01/2024.
//

import AutomaticSettings
import CoreUI
import SharedModels
import SwiftUI

/// Use this wrapper to bind between thew view model and TCA
struct DevSettingsViewWrapper: View {
    @ObserveInjection private var io

    @Binding
    var devSettings: DevSettings

    public init(devSettings: Binding<DevSettings>) {
        self._devSettings = devSettings
    }

    public var body: some View {
        DevSettingsView(viewModel: .init(
            settings: devSettings,
            externalData: .init(),
            save: { newValue in
                devSettings = newValue
            }, dismiss: {
                //
            }
        )
        )
        .enableInjection()
    }
}

struct DevSettingsView: View {
    @ObserveInjection private var io

    @ObservedObject
    var viewModel: AutomaticSettingsViewModel<DevSettings, DevSettingsExternalData>

    init(viewModel: AutomaticSettingsViewModel<DevSettings, DevSettingsExternalData>) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            List {
                credentialsLink(
                    headerView: {
                        Button("Save") {
                            viewModel.saveChanges()
                        }
                        .disabled(viewModel.applicableChanges.isEmpty)
                    }
                )
                themeLink()
            }
            .listStyle(.sidebar)
            .navigationBarTitle("Dev Settings")
            .navigationBarItems(
                trailing: Button("Save") { viewModel.saveChanges() }
                    .disabled(viewModel.applicableChanges.isEmpty)
            )
        }
        .enableInjection()
    }
}

// #Preview {
//    DevSettingsPage()
// }
