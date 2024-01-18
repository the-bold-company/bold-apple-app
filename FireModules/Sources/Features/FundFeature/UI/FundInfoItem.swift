//
//  FundInfoItem.swift
//
//
//  Created by Hien Tran on 18/01/2024.
//

import SwiftUI

struct FundInfoItem: View {
    let isLoading: Bool
    let title: String
    let value: String

    init(
        isLoading: Bool,
        title: String,
        value: String
    ) {
        self.isLoading = isLoading
        self.title = title
        self.value = value
    }

    var body: some View {
        HStack {
            Text(isLoading ? "Placeholder" : title)
            Spacer()
            Text(isLoading ? "Placeholder" : value)
        }
        .redacted(reason: isLoading ? .placeholder : [])
    }
}
