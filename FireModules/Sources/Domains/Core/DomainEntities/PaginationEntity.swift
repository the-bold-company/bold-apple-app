//
//  PaginationEntity.swift
//
//
//  Created by Hien Tran on 02/02/2024.
//

import Foundation

public struct PaginationEntity<M: Equatable & Identifiable & Hashable>: Equatable {
    public private(set) var currentPage: Int = 0
    public private(set) var items: [M]

    public init(currentPage: Int, items: [M]) {
        self.currentPage = currentPage
        self.items = items
    }

    public mutating func appendNewPage(newItems: [M]) {
        items.append(contentsOf: newItems)
    }
}
