//
//  ViewModifiers.swift
//
//
//  Created by Hien Tran on 14/01/2024.
//

import SwiftUI

public extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`(
        _ condition: @autoclosure () -> Bool,
        transform: (Self) -> some View
    ) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

struct IsHidden: ViewModifier {
    let hidden: Bool
    let reserveLayout: Bool

    func body(content: Content) -> some View {
        if hidden {
            if reserveLayout {
                content.hidden()
            }
        } else {
            content
        }
    }
}

public extension View {
    func isHidden(hidden: Bool, reserveLayout: Bool = false) -> some View {
        modifier(
            IsHidden(hidden: hidden, reserveLayout: reserveLayout)
        )
    }

    func hideNavigationBar() -> some View {
        #if os(iOS)
        return AnyView(navigationBarHidden(true))
        #endif
        return AnyView(self)
    }
}
