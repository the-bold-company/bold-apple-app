import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct TransactionCreationPage: View {
    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case amount
    }

    struct ViewState: Equatable {
        @BindingViewState var currentTransactionType: TransactionEntityType
        @BindingViewState var amount: Decimal
        @BindingViewState var date: Date
        @BindingViewState var category: Id
        @BindingViewState var transactionName: String
        @BindingViewState var notes: String
        @BindingViewState var selectedAccount: AnyAccount?
        var accountList: LoadingProgress<IdentifiedArrayOf<AnyAccount>, GetAccountListFailure>
        var moneyInCategories: LoadingProgress<IdentifiedArrayOf<MoneyInCategory>, GetCategoriesFailure>
        var createTransactionProgress: LoadingProgress<Transaction, CreateTransactionFailure>
    }

    let store: StoreOf<TransactionCreationFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, TransactionCreationFeature.Action>

    public init(store: StoreOf<TransactionCreationFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        VStack {
            Picker("Transaction type", selection: viewStore.$currentTransactionType) {
                _constructSegmentLabel("Tiền vào", systemImage: "plus.circle").tag(TransactionEntityType.moneyIn)
                _constructSegmentLabel("Tiền ra", systemImage: "minus.circle").tag(TransactionEntityType.moneyOut)
                _constructSegmentLabel("Chuyển nội bộ", systemImage: "arrow.left.arrow.right.circle").tag(TransactionEntityType.internalTransfer)
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .controlSize(.large)
            .padding(.horizontal, 20)

            inputForm
        }
        .padding(.top, 12)
        .background(Color(hex: 0xF2F4F7))
        .task {
            viewStore.send(.view(.onAppear))
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
                IfCaseLet2(
                    enum: viewStore.accountList,
                    casePath1: \.loaded.success,
                    content1: { accounts in
                        MacTextField(
                            title: "Số tiền *",
                            value: viewStore.$amount,
                            format: .currency(code: viewStore.selectedAccount?.currency.currencyCodeString ?? Currency.current.currencyCodeString
                            ),
                            prompt: "Nhập số tiền",
                            focusedField: $focusedField,
                            fieldId: .amount
                        )

                        MacPicker(
                            title: "Tài khoản",
                            selection: viewStore.$selectedAccount
                        ) {
                            ForEach(accounts, id: \.self) { acc in
                                Text("\(acc.name)")
                                    .font(.custom(FontFamily.Inter.medium, size: 12))
                                    .tag(Optional(acc))
                            }
                        }
                    },
                    casePath2: \.loading,
                    content2: { accountsDependentInputPlaceholder },
                    orElse: { accountsDependentInputPlaceholder }
                )

                DatePicker("Ngày ", selection: viewStore.$date, displayedComponents: [.date])

                HStack {
                    Text("Danh mục")
                    Spacer()
                    IfCaseLet2(
                        enum: viewStore.moneyInCategories,
                        casePath1: \.loaded.success,
                        content1: { categories in
                            Menu {
                                ForEach(categories.filter { $0.parentId == nil }, id: \.id) { parentCategory in
                                    let childCategories = categories.filter { $0.parentId == parentCategory.id }

                                    if !childCategories.isEmpty {
                                        Menu("✏️ \(parentCategory.name)") {
                                            ForEach(childCategories, id: \.id) { childCategory in
                                                Button("✏️ \(childCategory.name)") {
                                                    viewStore.send(.view(.selectCategory(childCategory.id)))
                                                }
                                            }
                                        }
                                    } else {
                                        Button("✏️ \(parentCategory.name)") {
                                            // viewStore.send(.view(.selectCategory(parentCategory.id)))
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("\(categories[id: viewStore.category]?.name ?? .init("None"))")
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 8, height: 8)
                                }
                                //                                .frame(minWidth: .infinity, alignment: .trailing)
                            }
                            .buttonStyle(.plain)

                        },
                        casePath2: \.loading,
                        content2: { ProgressView().controlSize(.mini) },
                        orElse: { ProgressView().controlSize(.mini) }
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
        actionButtons
    }

    @ViewBuilder
    private var moneyOutForm: some View {
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

                HStack {
                    Text("Danh mục")
                    Spacer()
                    IfCaseLet2(
                        enum: viewStore.moneyInCategories,
                        casePath1: \.loaded.success,
                        content1: { categories in
                            Menu {
                                ForEach(categories.filter { $0.parentId == nil }, id: \.id) { parentCategory in
                                    let childCategories = categories.filter { $0.parentId == parentCategory.id }

                                    if !childCategories.isEmpty {
                                        Menu("✏️ \(parentCategory.name)") {
                                            ForEach(childCategories, id: \.id) { childCategory in
                                                Button("✏️ \(childCategory.name)") {
                                                    viewStore.send(.view(.selectCategory(childCategory.id)))
                                                }
                                            }
                                        }
                                    } else {
                                        Button("✏️ \(parentCategory.name)") {
                                            // viewStore.send(.view(.selectCategory(parentCategory.id)))
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("\(categories[id: viewStore.category]?.name ?? .init("None"))")
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .buttonStyle(.plain)

                        },
                        casePath2: \.loading,
                        content2: { ProgressView().controlSize(.mini) },
                        orElse: { ProgressView().controlSize(.mini) }
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
        actionButtons
    }

    @ViewBuilder
    private var internalTransferForm: some View {
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
                    title: "Từ tài khoản",
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

                MacPicker(
                    title: "Đến tài khoản",
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
        actionButtons
    }

    @ViewBuilder
    private var accountsDependentInputPlaceholder: some View {
        LabeledContent("Số tiền *") {
            ProgressView().controlSize(.mini)
        }
        LabeledContent("Tài khoản") {
            ProgressView().controlSize(.mini)
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        HStack {
            Spacer()

            MacButton.secondary(
                action: { viewStore.send(.view(.cancelButtonTapped)) },
                label: {
                    Text("Hủy")
                }
            )

            MacButton.primary(
                disabled: false, // !viewStore.isFormValid,
                loading: viewStore.createTransactionProgress.is(\.loading),
                action: { viewStore.send(.view(.createTransactionButtonTapped)) },
                label: {
                    Text("Tạo")
                }
            )
        }
        .padding()
        .background(.white)
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

extension BindingViewStore<TransactionCreationFeature.State> {
    var viewState: TransactionCreationPage.ViewState {
        // swiftformat:disable redundantSelf
        .init(
            currentTransactionType: self.$transactionType,
            amount: self.$amount,
            date: self.$date,
            category: self.$category,
            transactionName: self.$transactionName,
            notes: self.$notes,
            selectedAccount: self.$referenceAccount,
            accountList: self.accountList,
            moneyInCategories: self.moneyInCategories,
            createTransactionProgress: self.createTransactionProgress
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    TransactionCreationPage(
        store: Store(
            initialState: .init(),
            reducer: { TransactionCreationFeature() }
        ) {
            $0.accountsAPIService = .directMock(getAccountListMock: accountListMock)
            $0.categoriesAPIService = .directMock(getCategoriesMock: categoryListMock, createCategoryMock: nil)
        }
    )
    .frame(height: 600)
}
