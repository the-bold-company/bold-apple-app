import CoreUI
import SwiftUI

public struct LoginPage: View {
    @ObserveInjection private var iO

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var verifiedPassword: String = ""
    @State private var isFormValid: Bool = false

    public init() {}

    public var body: some View {
        VStack(alignment: .leading) {
            Text("Log in")
                .typography(.titleScreen)

            Spacing(height: .size32)

            FireTextView(
                title: "Your email",
                text: $username
            )

            Spacing(height: .size16)

            FireTextView(
                title: "Your password",
                text: $username
            )

            Spacing(height: .size24)

            Button("Log in") {
                // Handle log in action
            }
            .fireButtonStyle()

            Spacer()
        }
        .padding()
        .enableInjection()
    }
}
