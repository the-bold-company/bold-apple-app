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
        @BindingViewState var currentTransactionType: TransactionType
        @BindingViewState var amount: Decimal
        @BindingViewState var date: Date
        @BindingViewState var category: Id
        @BindingViewState var transactionName: String
        var moneyInCategories: LoadingProgress<IdentifiedArrayOf<MoneyInCategory>, GetCategoriesFailure>
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
                _constructSegmentLabel("Tiền vào", systemImage: "plus.circle").tag(TransactionType.moneyIn)
                _constructSegmentLabel("Tiền ra", systemImage: "minus.circle").tag(TransactionType.moneyOut)
                _constructSegmentLabel("Chuyển nội bộ", systemImage: "arrow.left.arrow.right.circle").tag(TransactionType.internalTransfer)
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
    private var actionButtons: some View {
        HStack {
            Spacer()

            MacButton.secondary(
                action: { /* viewStore.send(.view(.cancelButtonTapped)) */ },
                label: {
                    Text("Hủy")
                }
            )

            MacButton.primary(
                disabled: false, // !viewStore.isFormValid,
                loading: false, // viewStore.accountCreationInProgress,
                action: { /* viewStore.send(.view(.createButtonTapped)) */ },
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
            moneyInCategories: self.moneyInCategories
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
            $0.categoriesAPIService = .directMock(
                getCategoriesMock: mock,
                createCategoryMock: nil
            )
        }
    )
    .frame(height: 600)
}

private let mock = """
{
    "message": "Execute successfully",
    "data": [
        {
            "id": "1ee5a461-7b00-473e-b23a-856173e7bf81",
            "type": "money-in",
            "icon": "green_square",
            "name": "Sugarbaby",
            "level": 0
        },
        {
            "id": "7a32b2cd-9159-4b0b-9c88-63200511aad6",
            "type": "money-in",
            "icon": "green_square",
            "name": "Baby 1",
            "level": 1,
            "parentId": "1ee5a461-7b00-473e-b23a-856173e7bf81"
        },
        {
            "id": "6547a713-d3df-423d-a764-b8d71af6d66a",
            "type": "money-in",
            "icon": "green_square",
            "name": "Baby 2",
            "level": 1,
            "parentId": "1ee5a461-7b00-473e-b23a-856173e7bf81"
        },
        {
            "id": "8cab19f6-59a9-4e39-b1bb-ded4d663567b",
            "type": "money-in",
            "icon": "green_square",
            "name": "Salary",
            "level": 0
        },
        {
            "id": "bb5195e3-6345-4d25-9622-e6d5c1be4eca",
            "type": "money-in",
            "icon": "green_square",
            "name": "Freelance",
            "level": 1,
            "parentId": "8cab19f6-59a9-4e39-b1bb-ded4d663567b"
        },
        {
            "id": "27e6a10b-34e2-45d2-a752-f3b8f105b6d0",
            "type": "money-in",
            "icon": "green_square",
            "name": "9-5",
            "level": 1,
            "parentId": "8cab19f6-59a9-4e39-b1bb-ded4d663567b"
        },
        {
            "id": "ebd779b3-93e3-497e-a9dd-fb2dde1e41b4",
            "type": "money-in",
            "icon": "green_square",
            "name": "stock",
            "level": 1,
            "parentId": "8cab19f6-59a9-4e39-b1bb-ded4d663567b"
        },
        {
            "id": "d371345e-6846-4f59-81dd-39bbfa7ddc41",
            "type": "money-in",
            "icon": "green_square",
            "name": "tiktok",
            "level": 1,
            "parentId": "8cab19f6-59a9-4e39-b1bb-ded4d663567b"
        },
        {
            "id": "3ae4bbc8-7948-4565-a852-97a6fac5f0c3",
            "type": "money-in",
            "icon": "green_square",
            "name": "Social Media",
            "level": 0
        },
        {
            "id": "c18b7311-b42b-45ac-810d-be214815efb4",
            "type": "money-in",
            "icon": "green_square",
            "name": "Youtube",
            "level": 1,
            "parentId": "3ae4bbc8-7948-4565-a852-97a6fac5f0c3"
        },
        {
            "id": "332fc28b-f55d-4672-b8af-71efcd6b4542",
            "type": "money-in",
            "icon": "green_square",
            "name": "X",
            "level": 1,
            "parentId": "3ae4bbc8-7948-4565-a852-97a6fac5f0c3"
        },
        {
            "id": "c5a3465e-b718-428e-bc37-f33ab8c3679e",
            "type": "money-in",
            "icon": "green_square",
            "name": "Instagram",
            "level": 1,
            "parentId": "3ae4bbc8-7948-4565-a852-97a6fac5f0c3"
        },
        {
          "id": "1ee5a461-7b00-473e-b23a-856173e7bf90",
          "type": "money-in",
          "icon": "green_square",
          "name": "Gambling",
          "level": 0
        },
        {
          "id": "1ee5a461-7b00-473e-b23a-856173e7bf91",
          "type": "money-in",
          "icon": "green_square",
          "name": "Inherit",
          "level": 0
        },
        {
          "id": "1ee5a461-7b00-473e-b23a-856173e7bf92",
          "type": "money-in",
          "icon": "green_square",
          "name": "Others",
          "level": 0
        },
        {
          "id": "1ee5a461-7b00-473e-b23a-856173e7bf93",
          "type": "money-in",
          "icon": "green_square",
          "name": "Back Street Boys",
          "level": 0
        }
    ],
    "code": 200
}
"""
