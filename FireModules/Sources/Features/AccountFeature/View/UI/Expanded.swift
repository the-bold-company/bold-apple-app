import SwiftUI

struct Expanded<Child>: View where Child: View {
    let color: Color
    let child: () -> Child

    init(
        color: Color = .clear,
        @ViewBuilder child: @escaping () -> Child
    ) {
        self.color = color
        self.child = child
    }

    var body: some View {
        ContainerRelativeShape()
            .fill(color)
            .overlay { child() }

//        ZStack {
//            color
//            child()
//        }
    }
}
