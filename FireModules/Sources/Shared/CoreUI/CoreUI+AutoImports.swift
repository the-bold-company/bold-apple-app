@_exported import Inject
@_exported import SwiftUIIntrospect

#if os(macOS)
    @_exported import AppKit
#elseif os(iOS)
    @_exported import UIKit
#endif

#if canImport(SwiftUI)
    @_exported import SwiftUI
#endif

#if os(macOS)
    public typealias PlatformColor = NSColor
    public typealias PlatformFont = NSFont
    public typealias PlatformViewRepresentable = NSViewRepresentable
#elseif os(iOS)
    public typealias PlatformColor = UIColor
    public typealias PlatformFont = UIFont
    public typealias PlatformViewRepresentable = UIViewRepresentable
#endif
