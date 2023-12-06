//
//  PasswordCreationPage.swift
//
//
//  Created by Hien Tran on 02/12/2023.
//

import ComposableArchitecture
import SwiftUI

public struct RegisterPasswordPage: View {
    let store: StoreOf<PasswordCreationFeature>

    public init(store: StoreOf<PasswordCreationFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Hello, Password creation!")
    }
}

// #Preview {
//    SwiftUIView()
// }
