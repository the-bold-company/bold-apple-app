import SwiftUI

public extension View {
    func slideOver(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        modifier(_SlideOverModifier(isPresented: isPresented, content: content))
    }
}

private struct _SlideOverModifier<V: View>: ViewModifier {
    @Binding var isPresented: Bool
    let content: () -> V

    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> V) {
        self._isPresented = isPresented
        self.content = content
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isPresented {
                        _SlideOverView(isPresented: $isPresented, content: self.content)
                            .animation(.easeInOut, value: isPresented)
                            .transition(.move(edge: .trailing))
                    }
                }
            )
    }
}

private struct _SlideOverView<Content: View>: View {
    let content: Content
    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                Color.clear
                if isPresented {
                    content
                        .frame(width: geometry.size.width * 0.5)
                        .frame(height: geometry.size.height)
                        .background(Color.white)
                        .offset(x: isPresented ? 0 : geometry.size.width)
                        .transition(.move(edge: .trailing))
                }
            }
//            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
            .animation(.easeInOut, value: isPresented)
        }
    }
}
