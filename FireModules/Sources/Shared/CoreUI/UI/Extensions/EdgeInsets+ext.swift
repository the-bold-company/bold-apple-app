//
//  EdgeInsets+ext.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import SwiftUI

public extension EdgeInsets {
    static func all(_ length: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: length, leading: length, bottom: length, trailing: length)
    }

    static func horizontal(_ length: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: 0, leading: length, bottom: 0, trailing: length)
    }

    static func vertical(_ length: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: length, leading: 0, bottom: length, trailing: 0)
    }

    static var zero: EdgeInsets {
        return EdgeInsets.all(0)
    }

    static func symetric(horizontal: CGFloat, vertical: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
