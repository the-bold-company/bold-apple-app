//
//  LandingPage.swift
//
//
//  Created by Hien Tran on 18/11/2023.
//

import CoreUI
import SwiftUI

public struct LandingPage: View {
    @ObserveInjection private var iO

    public init() {}

    public var body: some View {
        VStack {
            Spacer()

            Image(systemName: "globe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)

            Spacer().frame(height: 20)

            Text("Centralize your personal finance all in one place")
                .font(.custom(FontFamily.Inter.black, size: 28))
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            HStack(alignment: .center) {
                Button(action: {
                    // Handle log in action
                }) {
                    Text("Log in")
                        .font(.custom(FontFamily.Inter.semiBold, size: 14))
                        .foregroundColor(Color.coreui.forestGreen)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.coreui.brightGreen)
                        .cornerRadius(8)
                }

                Button(action: {
                    // Handle sign up action
                }) {
                    Text("Sign up")
                        .font(.custom(FontFamily.Inter.semiBold, size: 14))
                        .foregroundColor(Color.coreui.forestGreen)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.coreui.brightGreen)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .enableInjection()
    }
}
