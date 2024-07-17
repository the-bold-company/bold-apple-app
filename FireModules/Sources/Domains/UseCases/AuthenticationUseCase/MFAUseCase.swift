import ComposableArchitecture

public struct MFAUseCase: Sendable {
    public var validateMFA: @Sendable (_ input: MFAInput) -> MFAOutput
}
