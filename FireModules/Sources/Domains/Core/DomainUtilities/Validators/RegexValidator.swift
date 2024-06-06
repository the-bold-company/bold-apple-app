public enum Regex {
    public static let emailRegex = "[\\w._%+-|]+@[\\w0-9.-]+\\.[A-Za-z]{2,}"
    // //    "^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
}

public protocol RegexValidator: Validator where Input == String {
    var regex: String { get }
}
