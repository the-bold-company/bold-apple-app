import Codextended
import Foundation

public enum AccountType: String, Codable {
    case credit = "credit-account"
    case bank = "bank-account"
    case custom = "other"
}
