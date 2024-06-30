//
//  LoadingOverlay.swift
//
//
//  Created by Hien Tran on 27/11/2023.
//

import Inject
import SwiftUI

public struct LoadingOverlay<Content: View>: View {
    @ObserveInjection private var iO
    @ViewBuilder var content: () -> Content
    private var isLoading: Bool

    public init(loading: Bool, @ViewBuilder _ content: @escaping () -> Content) {
        self.isLoading = loading
        self.content = content
    }

    public var body: some View {
        ZStack {
            content()

            if isLoading {
                BlurView()
                    .edgesIgnoringSafeArea(.all)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .enableInjection()
    }
}

private struct BlurView: PlatformViewRepresentable {
    #if os(macOS)
    func makeNSView(context _: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .light
        view.blendingMode = .withinWindow
        view.state = .active
        return view
    }

    func updateNSView(_: NSVisualEffectView, context _: Context) {}
    #elseif os(iOS)
    func makeUIView(context _: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
    }

    func updateUIView(_: UIVisualEffectView, context _: Context) {}
    #endif
}
