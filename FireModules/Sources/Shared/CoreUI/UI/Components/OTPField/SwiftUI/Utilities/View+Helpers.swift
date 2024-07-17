//
//  View+Helpers.swift
//  AEOTPTextField
//
//  Created by Abdelrhman Eliwa on 01/06/2022.
//

import SwiftUI

@available(iOS 13.0, macOS 13.0, *)
public extension View {
    @_disfavoredOverload
    func onChange<V>(of value: V, perform action: @escaping (V) -> Void) -> some View where V: Equatable {
        if #available(iOS 14, macOS 14.0, *) {
            return onChange(of: value) { action($0) }
        } else {
            return modifier(ChangeObserver(newValue: value, action: { _, newValue in
                action(newValue)
            }))
        }
    }

    @_disfavoredOverload
    func onChange<V>(
        of value: V,
        perform action: @escaping (_ oldValue: V, _ newValue: V) -> Void
    ) -> some View where V: Equatable {
        if #available(iOS 14.0, macOS 14.0, *) {
            return onChange(of: value, action)
        } else {
            return modifier(ChangeObserver(newValue: value, action: action))
        }
    }
}
