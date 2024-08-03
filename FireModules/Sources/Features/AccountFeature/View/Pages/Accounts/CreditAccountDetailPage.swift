import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct CreditAccountDetailPage: View {
    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case accountName
        case balance
    }

    private enum Popover {
        case statementDate
        case paymentDueDate

        var explaination: String {
            switch self {
            case .statementDate:
                return "Là ngày ngân hàng chốt các giao dịch phát sinh từ thẻ tín dụng trong một chu kỳ."
            case .paymentDueDate:
                return "Là ngày bạn cần thanh toán cho ngân để tránh mất phí và lãi suất."
            }
        }
    }

    struct ViewState: Equatable {
        @BindingViewState var emoji: String?
        @BindingViewState var accountName: String
        @BindingViewState var balance: Decimal
        @BindingViewState var limit: Decimal?
        @BindingViewState var statementDate: Int?
        @BindingViewState var paymentDueDate: Int?
        @BindingViewState var currency: Currency
        var isFormValid: Bool
        var accountCreationInProgress: Bool
    }

    let store: StoreOf<CreditAccountDetailFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, CreditAccountDetailFeature.Action>

    @Dependency(\.date.now) var today

    private var todayDate: Int {
        Calendar.current.component(.day, from: today)
    }

    public init(store: StoreOf<CreditAccountDetailFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    @State private var statementDate: Int = 1
    @State private var paymentDueDate: Int = 1
    @State private var explainationPopover: Popover? = nil

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                MacForm {
                    Section {
                        MacTextField(
                            title: "Tên tài khoản *",
                            text: viewStore.$accountName,
                            prompt: "Ví dụ: Tài khoản ngân hàng XYZ",
                            focusedField: $focusedField,
                            fieldId: .accountName
                        )
                    } header: {
                        Text("TỔNG QUAN")
                            .font(.custom(FontFamily.Inter.regular, size: 12))
                            .foregroundColor(Color(hex: 0x9CA3AF))
                    }

                    Section {
                        MacTextField(
                            title: "Tổng hạn mức",
                            value: viewStore.$balance,
                            format: .currency(code: viewStore.currency.currencyCodeString),
                            prompt: "Default = 0",
                            focusedField: $focusedField,
                            fieldId: .balance
                        )

                        MacTextField(
                            title: "Dư nợ hiện tại",
                            value: viewStore.$balance,
                            format: .currency(code: viewStore.currency.currencyCodeString),
                            prompt: "Default = 0",
                            focusedField: $focusedField,
                            fieldId: .balance
                        )

                        MacPicker(
                            title: "Currency",
                            description: "Bạn sẽ không thể thay đổi đơn vị tiền tệ sau khi tạo",
                            selection: viewStore.$currency
                        ) {
                            ForEach(
                                CurrencyCode.allCases
                                    .filter { $0 != .none }
                                    .sorted(by: { $0.rawValue < $1.rawValue })
                                    .map(Currency.init(code:)),
                                id: \.self,
                                content: { currency in
                                    Text("\(currency.currencyCodeString) (\(currency.symbol))")
                                        .font(.custom(FontFamily.Inter.medium, size: 12))
                                        .tag(currency)
                                }
                            )
                        }
                    } header: {
                        Text("GIÁ TRỊ")
                            .font(.custom(FontFamily.Inter.regular, size: 12))
                            .foregroundColor(Color(hex: 0x9CA3AF))
                    }

                    Section {
                        Picker(selection: $statementDate) {
                            pickerContent()
                        } label: {
                            HStack(spacing: 4) {
                                Text("Ngày chốt sao kê")
                                Button {
                                    explainationPopover = .statementDate
                                } label: {
                                    Image(systemName: "info.circle")
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(Color(hex: 0x9CA3AF))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .popover(
                                    isPresented: Binding<Bool>(
                                        get: { explainationPopover == .statementDate },
                                        set: { newValue in
                                            if newValue {
                                                explainationPopover = .statementDate
                                            } else {
                                                explainationPopover = nil
                                            }
                                        }
                                    ),
                                    attachmentAnchor: .rect(.bounds),
                                    arrowEdge: .trailing
                                ) {
                                    popoverContens(geometry)
                                }
                            }
                        }

                        Picker(selection: $paymentDueDate) {
                            pickerContent()
                        } label: {
                            HStack(spacing: 4) {
                                Text("Ngày thanh toán")
                                Button {
                                    explainationPopover = .paymentDueDate
                                } label: {
                                    Image(systemName: "info.circle")
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(Color(hex: 0x9CA3AF))
                                }
                                .buttonStyle(PlainButtonStyle())
                                .popover(
                                    isPresented: Binding<Bool>(
                                        get: { explainationPopover == .paymentDueDate },
                                        set: { newValue in
                                            if newValue {
                                                explainationPopover = .paymentDueDate
                                            } else {
                                                explainationPopover = nil
                                            }
                                        }
                                    ),
                                    attachmentAnchor: .rect(.bounds), arrowEdge: .trailing
                                ) {
                                    popoverContens(geometry)
                                }
                            }
                        }
                    } header: {
                        Text("THỜI GIAN")
                            .font(.custom(FontFamily.Inter.regular, size: 12))
                            .foregroundColor(Color(hex: 0x9CA3AF))
                    }
                }

                Spacer()

                actionButtons(geometry)
            }
            .background(Color(hex: 0xF2F4F7))
        }
    }

    private func pickerContent() -> some View {
        ForEach(1 ..< 32) { day in
            Group {
                Text("\(day) hằng tháng ")
                    + Text(day == todayDate ? "(Hôm nay)" : "")
                    .foregroundColor(Color(hex: 0x9CA3AF))
            }.tag(day)
        }
    }

    private func actionButtons(_ geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()

            MacButton.secondary(
                action: { viewStore.send(.view(.cancelButtonTapped)) },
                label: { Text("Hủy") }
            )
            .frame(maxWidth: geometry.size.width / 4)

            MacButton.primary(
                disabled: !viewStore.isFormValid,
                loading: viewStore.accountCreationInProgress,
                action: { viewStore.send(.view(.createButtonTapped)) },
                label: { Text("Tạo") }
            )
            .frame(maxWidth: geometry.size.width / 4)
        }
        .padding()
        .background(.white)
    }

    private func popoverContens(_ geometry: GeometryProxy) -> some View {
        IfLet(data: explainationPopover?.explaination) { text in
            Expanded {
                // Apple is stupid enough to make it so hard to change the popover background. Here's the workaround -> https://stackoverflow.com/a/62489622/6254518
                Color(hex: 0x111827).scaleEffect(1.5)
                Text(text).typography(.bodySmall)
            }
            .foregroundColor(.white)
            .padding(8)
            .frame(width: geometry.size.width / 3)
        }
    }
}

extension BindingViewStore<CreditAccountDetailFeature.State> {
    var viewState: CreditAccountDetailPage.ViewState {
        // swiftformat:disable redundantSelf
        CreditAccountDetailPage.ViewState(
            emoji: self.$emoji,
            accountName: self.$accountNameText,
            balance: self.$balance,
            limit: self.$limit,
            statementDate: self.$statementDate,
            paymentDueDate: self.$statementDate,
            currency: self.$currency,
            isFormValid: self.accountName.isValid,
            accountCreationInProgress: self.createAccountProgress.is(\.loading)
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    CreditAccountDetailPage(
        store: Store(initialState: .init(), reducer: {
            CreditAccountDetailFeature()
        })
    )
    .frame(height: 500)
}
