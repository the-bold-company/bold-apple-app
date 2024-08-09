import Foundation

public struct Timestamp: Equatable {
    public var unix: TimeInterval { date.timeIntervalSince1970 }

    private let date: Date

    public init(_ date: Date) {
        self.date = date
    }
}
