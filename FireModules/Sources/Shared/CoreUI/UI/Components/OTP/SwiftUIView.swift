import SwiftUI

public struct MoukaOTPTextField<FocusField: Hashable>: View {
    @Binding private var text: String
    private var focusedField: FocusState<FocusField?>.Binding
    private var fieldId: FocusField?

    let title: String
    let placeholder: LocalizedStringKey?
    let error: String?

    public init(
        _ placeholder: LocalizedStringKey? = nil,
        title: String,
        text: Binding<String>,
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

            TextField(
                placeholder ?? "",
                text: $text,
                onEditingChanged: { _ in
                },
                onCommit: {}
            )
            #if os(macOS)
            .textFieldStyle(
                MoukaTextFieldStyle(
                    isFocused: focusedField.wrappedValue == fieldId,
                    isError: error != nil,
                    hidesSupplementary: true
                )
            )
            .introspect(.textField, on: .macOS(.v13, .v14, .v15)) {
                $0.focusRingType = .none
                $0.isBezeled = false
                $0.drawsBackground = true
                $0.backgroundColor = .white
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

public struct MOTPField: View {
    @Binding private var text: String
    @FocusState private var focusedField: FocusedField?
    @ObserveInjection var iO

    @State private var val = ""

    public init(
        text: Binding<String>
    ) {
        self._text = text
    }

    enum FocusedField: Hashable {
        case zero
        case one
        case two
        case three
        case four
        case five
    }

    public var body: some View {
        HStack(spacing: 12) {
            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 0 {
                            let index = text.index(text.startIndex, offsetBy: 0)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
                        if text.count == 0 {
                            text = value
                            focusedField = .one
                        }
                        print("zero: \(value)")
                    }
                ),
                focusedField: $focusedField,
                fieldId: .zero
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: val,
                text: Binding(
                    get: {
                        if text.count > 1 {
                            let index = text.index(text.startIndex, offsetBy: 1)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
                        print("one: \(value)")
                        if text.count == 1 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 1) ..< text.endIndex, with: value)
                            if !value.isEmpty {
                                focusedField = .two
                            }
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .one
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 2 {
                            let index = text.index(text.startIndex, offsetBy: 2)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
                        print("two: \(value)")
                        if text.count == 2 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 2) ..< text.endIndex, with: value)
                            if !value.isEmpty {
                                focusedField = .three
                            }
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .two
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 3 {
                            let index = text.index(text.startIndex, offsetBy: 3)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in

                        print("three: \(value)")

                        if text.count == 3 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 3) ..< text.endIndex, with: value)
                            if !value.isEmpty {
                                focusedField = .four
                            }
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .three
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 4 {
                            let index = text.index(text.startIndex, offsetBy: 4)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
                        print("four: \(value)")
                        if text.count == 4 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 4) ..< text.endIndex, with: value)
                            if !value.isEmpty {
                                focusedField = .five
                            }
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .four
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 5 {
                            let index = text.index(text.startIndex, offsetBy: 5)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
                        print("five: \(value)")
                        if text.count == 5 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 5) ..< text.endIndex, with: value)
//                            if !value.isEmpty {
//                                focusedField = .six
//                            }
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .five
            )
            .frame(width: 48, height: 62)
        }
        .frame(height: 62)
        .enableInjection()
    }
}

/*
 public struct OTPField: View {
     @Binding private var text: String
     @FocusState private var focusedField: FocusedField?

     @State private var val = ""

     public init(
         text: Binding<String>
     ) {
         self._text = text
     }

     enum FocusedField: Hashable {
         case zero
         case one
         case two
         case three
         case four
         case five
     }

     public var body: some View {
         HStack(spacing: 12) {
             MoukaOTPTextField(
                 title: "",
                 text: Binding(
                     get: {
                         if text.count > 0 {
                             let index = text.index(text.startIndex, offsetBy: 0)
                             return String(text[index])
                         } else {
                             return ""
                         }
                     },
                     set: { value in
                         if text.count == 0 {
                             text = value
                             focusedField = .one
                         } else if text.count == 1 {
                             text = text.replacingCharacters(in: text.startIndex..<text.endIndex, with: value)
                             focusedField = .one
                         }
 //                            else if text.count == 2 {
 //                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 1)..<text.endIndex, with: value)
 //                            focusedField = .three
 //                        } else if text.count == 3 {
 //                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 2)..<text.endIndex, with: value)
 //                            focusedField = .four // Move focus to the next field
 //                        } else if text.count == 4 {
 //                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 3)..<text.endIndex, with: value)
 //                            focusedField = .five // Move focus to the next field
 //                        } else if text.count == 5 {
 //                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 4)..<text.endIndex, with: value)
 //                            // You can add logic here to handle the last field, e.g., dismiss the keyboard
 //                        }
                     }
                 ),
                 focusedField: $focusedField,
                 fieldId: .zero
             )
             .frame(width: 48, height: 62)

             MoukaOTPTextField(
                 title: val,
                 text: Binding(
                     get: {
                         if text.count > 1 {
                             let index = text.index(text.startIndex, offsetBy: 1)
                             return String(text[index])
                         } else {
                             return ""
                         }
                     },
                     set: { value in
 //                        val = value
 //                        if text.count == 0 {
 //                            text = value
 //                            focusedField = .one
 //                        } else
 //                        if text.count == 1 {
 //                            text = text.replacingCharacters(in: text.startIndex..<text.endIndex, with: value)
 //                            focusedField = .two
 //                        } else
 //                        text = value
 //                        if value.isEmpty { return }
                         if text.count == 1 {
                             text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 1)..<text.endIndex, with: value)
                             if !value.isEmpty {
                                 focusedField = .two
                             }
                         } else if text.count == 2 {
                             if !value.isEmpty {
                                 text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 2)..<text.endIndex, with: value)
                                 focusedField = .two
                             }
                         }
 //                        else if text.count == 4 {
 //                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 3)..<text.endIndex, with: value)
 //                            focusedField = .five // Move focus to the next field
 //                        } else if text.count == 5 {
 //                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 4)..<text.endIndex, with: value)
 //                            // You can add logic here to handle the last field, e.g., dismiss the keyboard
 //                        }
                     }
                 ),
                 focusedField: $focusedField,
                 fieldId: .one
             )
             .frame(width: 48, height: 62)

             MoukaOTPTextField(
                 title: "",
                 text: Binding(
                     get: {
                         if text.count - 1 > 2 {
                             let index = text.index(text.startIndex, offsetBy: 2)
                             return String(text[index])
                         } else {
                             return ""
                         }
                     },
                     set: { value in
 //                        self.text += value
                     }
                 ),
                 focusedField: $focusedField,
                 fieldId: .two
             )
             .frame(width: 48, height: 62)

             MoukaOTPTextField(
                 title: "",
                 text: Binding(
                     get: {
                         if text.count - 1 > 3 {
                             let index = text.index(text.startIndex, offsetBy: 3)
                             return String(text[index])
                         } else {
                             return ""
                         }
                     },
                     set: { value in
 //                        self.text += value
                     }
                 ),
                 focusedField: $focusedField,
                 fieldId: .three
             )
             .frame(width: 48, height: 62)

             MoukaOTPTextField(
                 title: "",
                 text: Binding(
                     get: {
                         if text.count - 1 > 1 {
                             let index = text.index(text.startIndex, offsetBy: 4)
                             return String(text[index])
                         } else {
                             return ""
                         }
                     },
                     set: { value in
 //                        self.text += value
                     }
                 ),
                 focusedField: $focusedField,
                 fieldId: .four
             )
             .frame(width: 48, height: 62)

             MoukaOTPTextField(
                 title: "",
                 text: Binding(
                     get: {
                         if text.count - 1 > 1 {
                             let index = text.index(text.startIndex, offsetBy: 5)
                             return String(text[index])
                         } else {
                             return ""
                         }
                     },
                     set: { value in
 //                        self.text += value
                     }
                 ),
                 focusedField: $focusedField,
                 fieldId: .five
             )
             .frame(width: 48, height: 62)
         }
         .frame(height: 62)
     }
 }
 */

private struct Wrapper: View {
    enum Field: Hashable {
        case one
        case password
        case username
    }

    @FocusState var focusedField: Field?

    @State var text: String = ""

    var body: some View {
        VStack {
            MoukaOTPTextField(
                "",
                title: "Email",
                text: $text,
                focusedField: $focusedField,
                fieldId: .one
            )

//            .focused($focusedField, equals: .one)
        }
        .padding()
    }
}

#Preview {
    WithState(initialValue: "") { $text in
        MOTPField(text: $text)
        Text("\(text). count: \(text.count)")
    }
    .padding()
    .preferredColorScheme(.light)
    //    ExampleView()
    //    Wrapper()
}
