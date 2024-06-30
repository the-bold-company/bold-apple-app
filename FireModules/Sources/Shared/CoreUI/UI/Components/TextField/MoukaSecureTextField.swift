public struct MoukaSecureTextField<FocusField: Hashable>: View {
    @Binding private var text: String
    @State private var hidesText = true
    private var focusedField: FocusState<FocusField?>.Binding
    private var fieldId: FocusField?

    let title: String
    let placeholder: LocalizedStringKey?
    let error: String?

    public init(
        _ placeholder: LocalizedStringKey? = nil,
        title: String, text: Binding<String>,
        focusedField: FocusState<FocusField?>.Binding,
        fieldId: FocusField?,
        error: String? = nil
    ) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.focusedField = focusedField
        self.fieldId = fieldId
        self.error = error
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title).typography(.titleGroup)

            Spacing(height: .size8)

            if hidesText {
                SecureField(
                    placeholder ?? "",
                    text: $text,
                    onCommit: {}
                )
                #if os(macOS)
                .textFieldStyle(
                    MoukaTextFieldStyle(
                        isFocused: focusedField.wrappedValue == fieldId,
                        isError: error != nil,
                        hidesSupplementary: false,
                        supplementaryImage: { Image(systemName: "eye.fill") },
                        onSupplementaryButtonTapped: { hidesText = false }
                    )
                )
                .textFieldStyle(PlainTextFieldStyle()) // Need this to disable the NSSecureTextField border when typing
                .introspect(.secureField, on: .macOS(.v13, .v14, .v15)) {
                    $0.focusRingType = .none
                    $0.isBezeled = false
                    $0.drawsBackground = true
                    $0.backgroundColor = .clear
                    print($0.frame.height)
                }
                #elseif os(iOS)
                .autocapitalization(.none)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.coreui.contentPrimary, lineWidth: 1)
                )
                #endif
                .focused(focusedField, equals: fieldId)
            } else {
                TextField(
                    placeholder ?? "",
                    text: $text,
                    onEditingChanged: { _ in },
                    onCommit: {}
                )
                #if os(macOS)
                .textFieldStyle(
                    MoukaTextFieldStyle(
                        isFocused: focusedField.wrappedValue == fieldId,
                        isError: error != nil,
                        hidesSupplementary: false,
                        supplementaryImage: { Image(systemName: "eye.slash.fill") },
                        onSupplementaryButtonTapped: { hidesText = true }
                    )
                )
                .introspect(.textField, on: .macOS(.v13, .v14, .v15)) {
                    $0.focusRingType = .none
                    $0.isBezeled = false
                    $0.drawsBackground = true
                    $0.backgroundColor = .clear
                    print($0.frame.height)
                }
                #elseif os(iOS)
                .autocapitalization(.none)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.coreui.contentPrimary, lineWidth: 1)
                )
                #endif
                .focused(focusedField, equals: fieldId)
            }

            Group {
                Spacing(size: .size12)
                Text(error ?? "")
                    .typography(.bodyDefault)
                    .foregroundColor(Color(hex: 0xEF4444))
            }
            .isHidden(hidden: error == nil)
        }
    }
}

private struct MoukaSecureTextFieldWrapper: View {
    enum Field: Hashable {
        case email
        case password
        case username
    }

    @FocusState var focusedField: Field?

    @State var email: String = ""
    @State var password: String = ""
    @State var username: String = ""

    var body: some View {
        VStack(spacing: 24) {
            MoukaSecureTextField(
                "Nhập email",
                title: "Email",
                text: $email,
                focusedField: $focusedField,
                fieldId: .email
            )
            .focused($focusedField, equals: .email)

            MoukaSecureTextField(
                "Nhập mật khẩu",
                title: "Password",
                text: $password,
                focusedField: $focusedField,
                fieldId: .password
            )
            .focused($focusedField, equals: .password)

            MoukaSecureTextField(
                "Nhập username",
                title: "Username",
                text: $username,
                focusedField: $focusedField,
                fieldId: .username,
                error: "Input không hợp lệ. Bạn hãy thử lại nhé."
            )
            .focused($focusedField, equals: .password)
        }
        .padding()
    }
}

#Preview {
    MoukaSecureTextFieldWrapper()
}
