//
//  FundPickerPage.swift
//
//
//  Created by Hien Tran on 27/01/2024.
//

import ComposableArchitecture
import CoreUI
import SwiftUI

struct FundPickerPage: View {
    @ObserveInjection private var iO

    private let store: StoreOf<FundPickerReducer>

    public init(store: StoreOf<FundPickerReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                List(viewStore.funds) { fund in
                    Button {
                        viewStore.send(.fundSelected(id: fund.id))
                    } label: {
                        HStack {
                            Text(fund.name).typography(.bodyDefault)
                                .foregroundColor(.coreui.forestGreen)
                            Spacer()
                            if fund.id == viewStore.selectedFund {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .tag(Optional(fund.id))
                }
                .navigationBarItems(
                    leading: Button(action: {
                        viewStore.send(.removeSelection)
                    }) {
                        Text("Remove selection")
                            .typography(.bodyDefault)
                            .foregroundColor(.coreui.forestGreen)
                    },
                    trailing: Button(action: {
                        viewStore.send(.saveSelection(id: viewStore.selectedFund))
                    }) {
                        Text("Save")
                            .typography(.bodyDefault)
                            .foregroundColor(.coreui.forestGreen)
                    }
                )
            }
        }
        .enableInjection()
    }
}
