import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct TransactionDetailPage: View {
    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case amount
    }

    struct ViewState: Equatable {
        @BindingViewState var currentTransactionType: TransactionType
        @BindingViewState var amount: Decimal
        @BindingViewState var date: Date
        @BindingViewState var category: String
        @BindingViewState var transactionName: String
    }

    let store: StoreOf<TransactionDetailFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, TransactionDetailFeature.Action>

    public init(store: StoreOf<TransactionDetailFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        Expanded {
            VStack {
                Picker(selection: viewStore.$currentTransactionType, label: EmptyView()) {
                    _constructSegmentLabel("Tiền vào", systemImage: "plus.circle").tag(TransactionType.moneyIn)
                    _constructSegmentLabel("Tiền ra", systemImage: "minus.circle").tag(TransactionType.moneyOut)
                    _constructSegmentLabel("Chuyển nội bộ", systemImage: "arrow.left.arrow.right.circle").tag(TransactionType.internalTransfer)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)

                inputForm
            }
            .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    private var inputForm: some View {
        switch viewStore.currentTransactionType {
        case .moneyIn: moneyInForm
        case .moneyOut: moneyOutForm
        case .internalTransfer: internalTransferForm
        }
    }

    @ViewBuilder
    private var moneyInForm: some View {
        MacForm {
            Section {
                MacTextField(
                    title: "Số tiền *",
                    value: viewStore.$amount,
                    format: .currency(code: "VND" /* viewStore.currency.currencyCodeString */ ),
                    prompt: "Nhập số tiền",
                    focusedField: $focusedField,
                    fieldId: .amount
                )

                MacPicker(
                    title: "Tài khoản",
                    selection: .constant("")
                ) {
                    ForEach(
                        [
                            "Thẻ Timo - 1253",
                            "Tiền lẻ trong ví",
                            "Thẻ VPBank Shopee - 2028",
                        ],
                        id: \.self,
                        content: { acc in
                            Text(acc)
                                .font(.custom(FontFamily.Inter.medium, size: 12))
                                .tag(acc)
                        }
                    )
                }

                DatePicker("Ngày ", selection: viewStore.$date, displayedComponents: [.date])

                MacPicker(
                    title: "Danh mục",
                    selection: viewStore.$category
                ) {
                    ForEach(
                        [
                            "Không xác định (Mặc định)",
                            "Thu nhập",
                            "Đầu tư",
                            "Freelance",
                        ],
                        id: \.self,
                        content: { acc in
                            Text(acc)
                                .font(.custom(FontFamily.Inter.medium, size: 12))
                                .tag(acc)
                        }
                    )
                }

            } header: {
                Text("TỔNG QUAN")
                    .font(.custom(FontFamily.Inter.regular, size: 12))
                    .foregroundColor(Color(hex: 0x9CA3AF))
            }

            Section {
                MacTextField(
                    title: "Tên giao dịch",
                    text: viewStore.$transactionName,
                    prompt: "Nhập tên giao dịch",
                    focusedField: $focusedField,
                    fieldId: .amount
                )

                MacTextField(
                    title: "Ghi chú",
                    text: viewStore.$transactionName,
                    prompt: "Nhập ghi cú",
                    focusedField: $focusedField,
                    fieldId: .amount
                )
            } header: {
                Text("CHI TIẾT")
                    .font(.custom(FontFamily.Inter.regular, size: 12))
                    .foregroundColor(Color(hex: 0x9CA3AF))
            }
        }
    }

    @ViewBuilder
    private var moneyOutForm: some View {
        EmptyView()
    }

    @ViewBuilder
    private var internalTransferForm: some View {
        EmptyView()
    }

    @MainActor private func _constructSegmentLabel(_ text: LocalizedStringKey, systemImage: String) -> Image {
        // This is a hack as SwiftUI doesn't have an easy way to add image and text into your segment label
        // https://stackoverflow.com/a/78383432/6254518
        let view = Label(text, systemImage: systemImage)
            .font(.custom(FontFamily.Inter.medium, size: 12))

        let renderer = ImageRenderer(content: view)
        renderer.scale = 4.0

        return Image(nsImage: renderer.nsImage!)
    }
}

extension BindingViewStore<TransactionDetailFeature.State> {
    var viewState: TransactionDetailPage.ViewState {
        // swiftformat:disable redundantSelf
        .init(
            currentTransactionType: self.$transactionType,
            amount: self.$amount,
            date: self.$date,
            category: self.$category,
            transactionName: self.$transactionName
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    TransactionDetailPage(
        store: Store(
            initialState: .init(),
            reducer: { TransactionDetailFeature() }
        )
    )
    .frame(height: 700)
}
