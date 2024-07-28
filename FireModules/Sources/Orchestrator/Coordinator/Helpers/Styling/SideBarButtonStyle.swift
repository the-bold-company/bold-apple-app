import CoreUI
import SwiftUI

struct SideBarButtonStyle: ButtonStyle {
    let selected: Bool

    init(selected: Bool = false) {
        self.selected = selected
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.symetric(horizontal: 8, vertical: 8))
            .font(.custom(FontFamily.Inter.medium, size: 12))
            .foregroundColor(
                selected
                    ? Color(hex: 0x4C8A1D)
                    : Color(hex: 0x1F2937).opacity(configuration.isPressed ? 0.7 : 1)
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selected ? Color(hex: 0xECFAE2) : .clear)
            )
            .compositingGroup()
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
