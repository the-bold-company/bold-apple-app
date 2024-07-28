import CoreUI
import SwiftUI

public struct MacPicker<Content, Selection>: View
    where Selection: Hashable, Content: View
{
    @Binding var selection: Selection
    let title: LocalizedStringKey
    let description: LocalizedStringKey?
    @ViewBuilder var content: () -> Content

    public init(
        title: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        selection: Binding<Selection>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.description = description
        self._selection = selection
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Picker(title, selection: $selection, content: content)

            if let description {
                Text(description)
                    .font(.custom(FontFamily.Inter.regular, size: 12))
                    .foregroundStyle(Color(hex: 0x9CA3AF))
            }
        }
    }
}
