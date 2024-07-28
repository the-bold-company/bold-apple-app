import CoreUI
import SwiftUI

public struct MacForm<Content: View>: View {
    @ViewBuilder var content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        Form(content: content)
            .formStyle(MacFormStyle())
    }
}

private struct MacFormStyle: FormStyle {
    func makeBody(configuration: Configuration) -> some View {
        Form(configuration)
            .font(.custom(FontFamily.Inter.medium, size: 12))
            .textFieldStyle(.plain)
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
    }
}
