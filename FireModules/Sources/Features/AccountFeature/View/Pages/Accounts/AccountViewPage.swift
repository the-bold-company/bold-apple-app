import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct AccountViewPage: View {
    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case accountName
        case balance
    }

    struct ViewState: Equatable {
        @BindingViewState var emoji: String
        @BindingViewState var accountName: String
        @BindingViewState var balance: Decimal
        @BindingViewState var currency: Currency
    }

    let store: StoreOf<AccountViewFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, AccountViewFeature.Action>

    public init(store: StoreOf<AccountViewFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

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
                            title: "Số tiền hiện có *",
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
                }

                Spacer()

                HStack {
                    Spacer()

                    MacButton.secondary(
                        action: {},
                        label: { Text("Hủy") }
                    )
                    .frame(maxWidth: geometry.size.width / 4)

                    MacButton.primary(
                        disabled: false,
                        loading: false,
                        action: {},
                        label: { Text("Tạo") }
                    )
                    .frame(maxWidth: geometry.size.width / 4)
                }
                .padding()
                .background(.white)
            }
            .background(Color(hex: 0xF2F4F7))
        }
    }
}

extension BindingViewStore<AccountViewFeature.State> {
    var viewState: AccountViewPage.ViewState {
        // swiftformat:disable redundantSelf
        AccountViewPage.ViewState(
            emoji: self.$emoji,
            accountName: self.$accountNameText,
            balance: self.$balance,
            currency: self.$currency
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    AccountViewPage(
        store: Store(initialState: .init(), reducer: {
            AccountViewFeature()
        })
    )
}
