//
//  Spacing.swift
//
//
//  Created by Hien Tran on 22/11/2023.
//

import SwiftUI

public enum Size: CGFloat {
    case size4 = 4
    case size8 = 8
    case size12 = 12
    case size16 = 16
    case size24 = 24
    case size32 = 32
    case size40 = 40
    case size48 = 48
    case size56 = 56
    case size64 = 64
    case size72 = 72
    case size80 = 80
    case size88 = 88
    case size96 = 96
    case size104 = 104
    case size112 = 112
    case size120 = 120
    case size128 = 128
}

public struct Spacing: View {
    let width: CGFloat?
    let height: CGFloat?

    public init(height size: Size) {
        self.init(height: size.rawValue)
    }

    public init(width size: Size) {
        self.init(width: size.rawValue)
    }

    public init(size: Size) {
        self.init(width: size.rawValue, height: size.rawValue)
    }

    private init(width: CGFloat? = nil, height: CGFloat? = nil) {
        precondition(width != nil || height != nil, "`width` and `height` cannot simutaneously be nil")
        self.width = width
        self.height = height
    }

    public var body: some View {
        Spacer().frame(width: width, height: height)
    }
}

// TODO: Use Sourcery to generate this
extension Spacing {
    static let height4 = Spacing(height: .size4)
    static let height8 = Spacing(height: .size8)
}
