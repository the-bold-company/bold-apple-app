struct MoukaTextFieldStyle: TextFieldStyle {
    @State private var isHovered = false
    private var isFocused: Bool
    private var isError: Bool
    private let hidesSupplementary: Bool
    private var supplementaryImage: (() -> Image)?
    private let onSupplementaryButtonTapped: (() -> Void)?

    init(
        isFocused: Bool,
        isError: Bool,
        hidesSupplementary: Bool,
        supplementaryImage: (() -> Image)? = nil,
        onSupplementaryButtonTapped: (() -> Void)? = nil
    ) {
        self.isFocused = isFocused
        self.isError = isError
        self.hidesSupplementary = hidesSupplementary
        self.supplementaryImage = supplementaryImage
        self.onSupplementaryButtonTapped = onSupplementaryButtonTapped
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            configuration
                .typography(.bodyLarge)
                .frame(height: 25)
                .padding(.vertical(14))
                .padding(.leading, 16)
                .padding(.trailing, onSupplementaryButtonTapped != nil ? 40 : 16)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isError
                                ? Color(red: 0.94, green: 0.27, blue: 0.27).opacity(0.25)
                                : isFocused
                                ? Color(red: 0.62, green: 0.91, blue: 0.44).opacity(0.5)
                                : .clear,
                            lineWidth: 4
                        )
                        .padding(-2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            isError
                                ? Color(hex: 0xEF4444)
                                : isHovered || isFocused
                                ? .coreui.matureGreen
                                : Color(hex: 0xE5E7EB),
                            lineWidth: 1
                        )
                )
                .onHover { isHovered = $0 }

            if let onSupplementaryButtonTapped {
                HStack {
                    Spacer()
                    Button {
                        onSupplementaryButtonTapped()
                    } label: {
                        (supplementaryImage?() ?? Image(systemName: "xmark.circle.fill"))
                            .foregroundColor(Color(hex: 0x9CA3AF))
                    }
                    .buttonStyle(.plain)
                    .frame(width: 16, height: 16)
                    .isHidden(hidden: hidesSupplementary)
                    Spacing(width: .size16)
                }
            }
        }
    }
}
