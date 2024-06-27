import CoreUI
import SwiftUI

public struct UnderConstructionPage: View {
    @ObserveInjection private var iO
    public init() {}
    public var body: some View {
        VStack(alignment: .leading) {
            FireNavBar(
                trailing: {
                    DismissButton(image: {
                        Image(systemName: "xmark")
                    })
                }
            )

            VStack {
                Spacer()
                Image(systemName: "hammer.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)

                Spacing(size: .size24)

                Text("""
                This feature is under construction
                Please come back later
                """)
                .typography(.bodyDefaultBold)
                .multilineTextAlignment(.center)
                .padding()

                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .hideNavigationBar()
        .padding()
        .enableInjection()
    }
}
