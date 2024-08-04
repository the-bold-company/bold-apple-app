import Codextended
import DomainEntities
import Foundation

public struct AccountAPIResponse: Decodable {
    public let id: String
    public let name: String
    public let type: String
    public let status: String
    public let icon: String?
    public let currencyId: String
    public let userId: String
    public let cells: [Cell]

    public struct Cell: Decodable {
        public var id: String
        public let name: String
        public let value: AccountCellValue
        public let title: String
        public var createBy: String
        public var accountId: String
        public var index: Int

        public init(from decoder: any Decoder) throws {
            self.id = try decoder.decode("id")
            self.name = try decoder.decode("name")
            self.createBy = try decoder.decode("createdBy")
            self.accountId = try decoder.decode("accountId")
            self.value = try AccountCellValue(from: decoder)
            self.title = try decoder.decode("title")
            self.index = try decoder.decode("index")
        }
    }

    public init(from decoder: any Decoder) throws {
        self.id = try decoder.decode("id")
        self.userId = try decoder.decode("userId")
        self.name = try decoder.decode("name")
        self.type = try decoder.decode("type")
        self.status = try decoder.decode("status")
        self.icon = try decoder.decodeIfPresent("icon")
        self.currencyId = try decoder.decode("currencyId")
        self.cells = try decoder.decode("cells")
    }
}

public extension AccountAPIResponse.Cell {
    var asBankAccountBalanceCell: BankAccountBalanceCell? {
        guard let number = value[case: \.number] else { return nil }

        let balanceCell = BankAccountBalanceCell(value: number)

        if balanceCell.name == name, balanceCell.title == title {
            return balanceCell
        } else {
            return nil
        }
    }

    var asCreditAccountBalanceCell: CreditAccountBalanceCell? {
        guard let number = value[case: \.number] else { return nil }

        let balanceCell = CreditAccountBalanceCell(value: number)

        if balanceCell.name == name, balanceCell.title == title {
            return balanceCell
        } else {
            return nil
        }
    }

    var asCreditAccountLimitCell: CreditAccountLimitCell? {
        guard let number = value[case: \.number] else { return nil }

        let cell = CreditAccountLimitCell(value: number)

        if cell.name == name, cell.title == title {
            return cell
        } else {
            return nil
        }
    }

    var asCreditAccountStatementClosingDateCell: CreditAccountStatementClosingDateCell? {
        guard let number = value[case: \.number] else { return nil }

        let numberAsInt = NSDecimalNumber(decimal: number).intValue
        let cell = CreditAccountStatementClosingDateCell(value: numberAsInt)

        if cell.name == name, cell.title == title {
            return cell
        } else {
            return nil
        }
    }

    var asCreditAccountPaymentDueDateCell: CreditAccountPaymentDueDateCell? {
        guard let number = value[case: \.number] else { return nil }

        let numberAsInt = NSDecimalNumber(decimal: number).intValue
        let cell = CreditAccountPaymentDueDateCell(value: numberAsInt)

        if cell.name == name, cell.title == title {
            return cell
        } else {
            return nil
        }
    }
}

public extension AccountAPIResponse {
    var asBankAccountEntity: BankAccount? {
        guard let accountType = AccountType(rawValue: type),
              accountType == .bank
        else { return nil }

        guard let balanceCell = cells
            .compactMap(\.asBankAccountBalanceCell)
            .first
        else { return nil }

        return BankAccount(
            id: Id(id),
            name: DefaultLengthConstrainedString(name),
            type: accountType,
            status: status,
            icon: icon,
            userId: Id(userId),
            balance: Money(balanceCell.value, codeString: currencyId)
        )
    }

    var asCreditAccountEntity: CreditAccount? {
        guard let accountType = AccountType(rawValue: type),
              accountType == .credit
        else { return nil }

        var balanceCell: CreditAccountBalanceCell?
        var limitCell: CreditAccountLimitCell?
        var statementClosingDateCell: CreditAccountStatementClosingDateCell?
        var paymentDueDateCell: CreditAccountPaymentDueDateCell?

        cells.forEach {
            if let cell = $0.asCreditAccountBalanceCell {
                balanceCell = cell
            } else if let cell = $0.asCreditAccountLimitCell {
                limitCell = cell
            } else if let cell = $0.asCreditAccountStatementClosingDateCell {
                statementClosingDateCell = cell
            } else if let cell = $0.asCreditAccountPaymentDueDateCell {
                paymentDueDateCell = cell
            }
        }

        guard let balanceCell, let statementClosingDateCell, let paymentDueDateCell, let limitCell
        else { return nil }

        return CreditAccount(
            id: Id(id),
            name: DefaultLengthConstrainedString(name),
            type: accountType,
            status: status,
            icon: icon,
            userId: Id(userId),
            balance: Money(balanceCell.value, codeString: currencyId),
            limit: Money(limitCell.value, codeString: currencyId),
            paymentDueDate: paymentDueDateCell.value,
            statementDate: statementClosingDateCell.value
        )
    }

    var asAnyAccount: AnyAccount? {
        if let bankAccount = asBankAccountEntity {
            return AnyAccount(bankAccount)
        } else if let creditAccount = asCreditAccountEntity {
            return AnyAccount(creditAccount)
        }
        return nil
    }
}
