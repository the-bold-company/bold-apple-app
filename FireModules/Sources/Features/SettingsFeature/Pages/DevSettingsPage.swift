//
//  DevSettingsPage.swift
//
//
//  Created by Hien Tran on 19/01/2024.
//

import AutomaticSettings
import CoreUI
import SharedModels
import SwiftUI

public struct DevSettingsPage: View {
    @ObserveInjection private var io

    @ObservedObject
    var viewModel: AutomaticSettingsViewModel<DevSettings, DevSettingsExternalData>

    public init(viewModel: AutomaticSettingsViewModel<DevSettings, DevSettingsExternalData>) {
        self.viewModel = viewModel
    }

    public var body: some View {
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
