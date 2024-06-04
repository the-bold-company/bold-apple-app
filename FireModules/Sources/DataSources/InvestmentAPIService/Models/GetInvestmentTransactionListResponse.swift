import Codextended
import DomainEntities
import Foundation

struct GetInvestmentTransactionListResponse: Decodable {
    let transactions: [RecordTransactionRespose]

    init(from decoder: Decoder) throws {
        self.transactions = try decoder.decode("transactions")
    }
}

extension GetInvestmentTransactionListResponse {
    func asInvestmentTransactionEntities() -> [InvestmentTransactionEntity] {
        return transactions.map { $0.asInvestmentTransactionEntity() }
    }
}
