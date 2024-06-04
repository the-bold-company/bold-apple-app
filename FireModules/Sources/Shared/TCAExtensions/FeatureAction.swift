import ComposableArchitecture

protocol TCAFeatureAction {
    associatedtype ViewAction
    associatedtype DelegateAction
    associatedtype LocalAction

    static func view(_: ViewAction) -> Self
    static func delegate(_: DelegateAction) -> Self
    static func _local(_: LocalAction) -> Self
}
