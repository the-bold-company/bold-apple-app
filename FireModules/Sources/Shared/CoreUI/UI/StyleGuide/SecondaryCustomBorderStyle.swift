import SwiftUI

public struct SecondaryCustomBorderStyle: ButtonStyle {
    public init(
        shape: FireButtonShape = .roundedCorner,
        borderColor: Color,
        backgroundColor: Color?,
        textColor: Color?,
        isActive: Bool
    ) {
        self.shape = shape
        self.buttonType = FireButtonType.secondary(shape: shape)
        self.isActive = isActive
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }

    let shape: FireButtonShape
    let isActive: Bool
    let borderColor: Color
    let buttonType: FireButtonType
    let backgroundColor: Color?
    let textColor: Color?

    public func makeBody(configuration: SecondaryCustomBorderStyle.Configuration) -> some View {
        configuration.label
            .font(.custom(FontFamily.Inter.semiBold, size: 14))
            .foregroundColor((textColor ?? borderColor).foregroundOpacity(isActive: isActive))
            .padding(buttonType.padding)
            .if(shape == .capsule) {
                $0.background(
                    Capsule(style: .circular)
                        .fill(
                            (backgroundColor ?? buttonType.backgroundColor)
                                .backgroundOpacity(isActive: isActive, isPressed: configuration.isPressed)
                        )
                )
                .overlay {
                    Capsule()
                        .stroke(
                            borderColor
                                .backgroundOpacity(isActive: isActive, isPressed: configuration.isPressed),
                            lineWidth: 1
                        )
                }
            }
            .if(shape == .roundedCorner) {
                $0.background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            (backgroundColor ?? buttonType.backgroundColor)
                                .backgroundOpacity(isActive: isActive, isPressed: configuration.isPressed)
                        )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            borderColor
                                .backgroundOpacity(isActive: isActive, isPressed: configuration.isPressed),
                            lineWidth: 1
                        )
                }
            }
            .compositingGroup()
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
