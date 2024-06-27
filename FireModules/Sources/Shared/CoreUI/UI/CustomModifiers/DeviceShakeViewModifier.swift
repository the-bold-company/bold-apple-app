//
//  DeviceShakeViewModifier.swift
//
//
//  Created by Hien Tran on 21/01/2024.
//

import Foundation
import SwiftUI

#if os(iOS)
    import UIKit

    extension UIDevice {
        static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
    }

    extension UIWindow {
        override open func motionEnded(_ motion: UIEvent.EventSubtype, with _: UIEvent?) {
            if motion == .motionShake {
                NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
            }
        }
    }

    public struct DeviceShakeViewModifier: ViewModifier {
        let action: () -> Void

        public init(action: @escaping () -> Void) {
            self.action = action
        }

        public func body(content: Content) -> some View {
            content
                .onAppear()
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                    action()
                }
        }
    }

    public extension View {
        func onShake(perform action: @escaping () -> Void) -> some View {
            modifier(DeviceShakeViewModifier(action: action))
        }
    }

#endif
