import Foundation

public protocol BaseAccountCell {
    associatedtype Value
    var name: String { get }
    var value: Value { get }
    var title: String { get }

    init(value: Value)
}

public struct BankAccountBalanceCell: BaseAccountCell {
    public let name = "BANK_ACCOUNT_CURRENT_BALANCE"
    public let value: Decimal
    public let title = "Số tiền hiện có"

    public init(value: Decimal) {
        self.value = value
    }
}

public struct CreditAccountLimitCell: BaseAccountCell {
    public let name = "CREDIT_ACCOUNT_TOTAL_CREDIT_LIMIT"
    public let value: Decimal
    public let title = "Tổng hạn mức"

    public init(value: Decimal) {
        self.value = value
    }
}

public struct CreditAccountBalanceCell: BaseAccountCell {
    public let name = "CREDIT_ACCOUNT_CURRENT_DEBT"
    public let value: Decimal
    public let title = "Dư nợ hiện tại"

    public init(value: Decimal) {
        self.value = value
    }
}

public struct CreditAccountStatementClosingDateCell: BaseAccountCell {
    public let name = "CREDIT_ACCOUNT_STATEMENT_CLOSING_DATE"
    public let value: Int
    public let title = "Ngày chốt sao kê"

    public init(value: Int) {
        self.value = value
    }
}

public struct CreditAccountPaymentDueDateCell: BaseAccountCell {
    public let name = "CREDIT_ACCOUNT_PAYMENT_DATE"
    public let value: Int
    public let title = "Sao kê hàng tháng"

    public init(value: Int) {
        self.value = value
    }
}
