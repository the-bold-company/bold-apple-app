import CoreUI
import SwiftUI

public struct OnboardingPage: View {
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
                .typography(.titleSection)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
        .enableInjection()
    }
}
