import CoreUI
import SwiftUI

public struct MacTextField<Format: ParseableFormatStyle, FocusField: Hashable>: View where Format.FormatOutput == String {
    private var focusedField: FocusState<FocusField?>.Binding
    private var fieldId: FocusField?

    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void

    let title: String
    let error: String?
    let prompt: String?

    @Binding private var value: Format.FormatInput
    private let format: Format

    public init(
        title: String,
        value: Binding<Format.FormatInput>,
        format: Format,
        prompt: String? = nil,
        focusedField: FocusState<FocusField?>.Binding,
        fieldId: FocusField?,
        error: String? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) where Format.FormatOutput == String {
        self.title = title
        self._value = value
        self.format = format
        self.prompt = prompt
        self.focusedField = focusedField
        self.fieldId = fieldId
        self.error = error
        self.onEditingChanged = onEditingChanged ?? { _ in }
        self.onCommit = onCommit ?? {}
    }

    public init(
        title: String,
        text: Binding<String>,
        prompt: String? = nil,
        focusedField: FocusState<FocusField?>.Binding,
        fieldId: FocusField?,
        error: String? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) where Format == String.FormatStyle.None {
        self.title = title
        self._value = text
        self.format = .none
        self.prompt = prompt
        self.focusedField = focusedField
        self.fieldId = fieldId
        self.error = error
        self.onEditingChanged = onEditingChanged ?? { _ in }
        self.onCommit = onCommit ?? {}
    }

    public init(
        title: String,
        text: Binding<String?>,
        prompt: String? = nil,
        focusedField: FocusState<FocusField?>.Binding,
        fieldId: FocusField?,
        error: String? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) where Format == String?.FormatStyle<String.FormatStyle.None> {
        self.title = title
        self._value = text
        self.format = .optional
        self.prompt = prompt
        self.focusedField = focusedField
        self.fieldId = fieldId
        self.error = error
        self.onEditingChanged = onEditingChanged ?? { _ in }
        self.onCommit = onCommit ?? {}
    }

    public var body: some View {
        VStack(alignment: .leading) {
            TextField(
                title,
//                text: $text,
                value: $value,
                format: format,
                prompt: prompt != nil ? Text(prompt!) : nil
//                onEditingChanged: onEditingChanged,
//                onCommit: onCommit
            )
            .onSubmit {
                onCommit()
            }
            #if os(iOS)
            .autocapitalization(.none)
            #endif
            .focused(focusedField, equals: fieldId)

            Text(error ?? "")
                .font(.custom(FontFamily.Inter.medium, size: 12))
                .foregroundColor(Color(hex: 0xEF4444))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .isHidden(hidden: error == nil)
        }
//        .padding(.zero)
//        .overlay {
//            Rectangle()
//                .stroke(
//                    .yellow,
//                    lineWidth: 1
//                )
//        }
    }
}

public extension ParseableFormatStyle where Self == String.FormatStyle.None {
    static var none: Self { .init() }
}

public extension ParseableFormatStyle where Self == String?.FormatStyle<String.FormatStyle.None> {
    static var optional: Self { .init(formatter: .none) }
}

public extension ParseableFormatStyle where Self == Decimal?.FormatStyle<Decimal.FormatStyle.Currency> {
    static func currency(code: String) -> Self {
        .init(formatter: .currency(code: code))
    }
}

public extension String {
    enum FormatStyle {
        public struct None: ParseableFormatStyle {
            public var parseStrategy: Strategy { Strategy() }

            public func format(_ value: String) -> String {
                return value
            }

            public struct Strategy: ParseStrategy {
                public func parse(_ value: String) throws -> String {
                    return value
                }
            }
        }
    }
}

public extension Optional {
    struct FormatStyle<Format: ParseableFormatStyle>: ParseableFormatStyle where Format.FormatOutput == String, Format.FormatInput == Wrapped {
        public var parseStrategy: Strategy<Format.Strategy> { Strategy(strategy: formatter.parseStrategy) }

        private let formatter: Format

        public init(formatter: Format) {
            self.formatter = formatter
        }

        public func format(_ value: Format.FormatInput?) -> String {
            guard let value else { return "" }

            return formatter.format(value)
        }

        public struct Strategy<OutputStrategy: ParseStrategy>: ParseStrategy where OutputStrategy.ParseInput == String {
            private let strategy: OutputStrategy

            public init(strategy: OutputStrategy) {
                self.strategy = strategy
            }

            public func parse(_ value: String) throws -> OutputStrategy.ParseOutput? {
                guard !value.isEmpty else { return nil }
                return try strategy.parse(value)
            }
        }
    }
}

private struct Wrapper: View {
    enum Field: Hashable {
        case email
        case password
        case username
        case balance
    }

    @FocusState var focusedField: Field?

    @State var email: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var amount: Decimal = 0
    @State var currency: String = "VND (₫)"
    @State var currency2: String = "USD ($)"

    let currencies = ["VND (₫)", "USD ($)", "GBP (£)", "EUR (€)"]

    var body: some View {
        MacForm {
            MacTextField(
                title: "Email",
                text: $email,
                prompt: "Eg: dev@mouka.ai",
                focusedField: $focusedField,
                fieldId: .email
            )

            MacTextField(
                title: "Password",
                text: $password,
                focusedField: $focusedField,
                fieldId: .password
            )

            MacTextField(
                title: "Username",
                text: $username,
                prompt: "E.g: moukadev",
                focusedField: $focusedField,
                fieldId: .username,
                error: "Input không hợp lệ. Bạn hãy thử lại nhé."
            )

            MacTextField(
                title: "Balance",
                value: $amount,
                format: .currency(code: "VND"),
                focusedField: $focusedField,
                fieldId: .balance
            )

            MacPicker(
                title: "Currency",
                selection: $currency
            ) {
                ForEach(
                    currencies,
                    id: \.self,
                    content: { currency in
                        Text(currency)
                            .font(.custom(FontFamily.Inter.medium, size: 12))
                            .tag(currency)
                    }
                )
            }

            MacPicker(
                title: "Currency",
                description: "Bạn sẽ không thể thay đổi đơn vị tiền tệ sau khi tạo",
                selection: $currency2
            ) {
                ForEach(
                    currencies,
                    id: \.self,
                    content: { currency in
                        Text(currency)
                            .font(.custom(FontFamily.Inter.regular, size: 12))
                            .tag(currency)
                    }
                )
            }
        }
    }
}

#Preview {
    Wrapper()
}
