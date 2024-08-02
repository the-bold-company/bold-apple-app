import SwiftUI

struct IfLet<Data, Content>: View where Content: View {
    let data: Data?

    let content: (Data) -> Content

    init(
        data: Data?,
        @ViewBuilder content: @escaping (Data) -> Content
    ) {
        self.data = data
        self.content = content
    }

    var body: some View {
        if let data {
            content(data)
        }
    }
}
