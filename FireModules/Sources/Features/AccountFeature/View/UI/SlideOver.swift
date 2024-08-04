import ComposableArchitecture
import SwiftUI

public extension View {
    func slideOver(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        modifier(_SlideOverModifier(isPresented: isPresented, content: content))
    }

    func slideOver<Item>(
        data: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> some View
    ) -> some View where Item: Identifiable, Item: Equatable {
        modifier(_SlideOverModifier2(data: data, onDismiss: onDismiss, content: content))
    }
}

private extension Binding {
    func isPresent<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        .init(
            get: { self.wrappedValue != nil },
            set: { isPresented in
                if !isPresented {
                    self.wrappedValue = nil
                }
            }
        )
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

private struct _SlideOverModifier2<Item, SlideOverContent>: ViewModifier where Item: Identifiable, Item: Equatable, SlideOverContent: View {
    private var onDismiss: (() -> Void)?
    @Binding var data: Item?
    @ViewBuilder private var content: (Item) -> SlideOverContent

    init(
        data: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> SlideOverContent
    ) {
        self._data = data
        self.onDismiss = onDismiss
        self.content = content
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    IfLet(data: data) { unwrapped in
//                    if let data {
//                        slideOverContent(for: data)
                        _SlideOverView(isPresented: $data.isPresent(), content: { self.content(unwrapped) })
                    }
                    .animation(.easeInOut, value: data)
                    .transition(.move(edge: .trailing))
                }
            )
    }

    @ViewBuilder
    private func slideOverContent(for item: Item) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                Color.clear
                content(item)
                    .frame(width: geometry.size.width * 0.5)
                    .frame(height: geometry.size.height)
                    .background(Color.white)
                    .offset(x: data != nil ? 0 : geometry.size.width)
                    .transition(.move(edge: .trailing))
            }
//            .background(
//                Color.black.opacity(0.4)
//                    .edgesIgnoringSafeArea(.all)
//                    .onTapGesture {
//                        withAnimation {
//                            self.dismiss()
//                        }
//                    }
//            )
            .animation(.easeInOut, value: data)
        }
    }

//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .trailing) {
//                Color.clear
//                if isPresented {
//                    content
//                        .frame(width: geometry.size.width * 0.5)
//                        .frame(height: geometry.size.height)
//                        .background(Color.white)
//                        .offset(x: isPresented ? 0 : geometry.size.width)
//                        .transition(.move(edge: .trailing))
//                }
//            }
    ////            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
//            .animation(.easeInOut, value: isPresented)
//        }
//    }
}
