public protocol HasId {
    var id: Id { get }
}

public protocol HasCreatedBy {
    var createBy: Id { get }
}

public protocol HasAccountId {
    var accountId: Id { get }
}

public protocol HasUserId {
    var userId: Id { get }
}
