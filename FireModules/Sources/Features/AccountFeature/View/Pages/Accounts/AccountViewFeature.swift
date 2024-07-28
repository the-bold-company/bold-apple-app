import ComposableArchitecture
import DomainEntities
import Foundation
import TCAExtensions

@Reducer
public struct AccountViewFeature {
    public struct State: Equatable {
        @BindingState var emoji: String = ""
        @BindingState var accountNameText: String = ""
        @BindingState var balance: Decimal = 0
        @BindingState var currency: Currency = .current

        var createAccountProgress: LoadingProgress<String, CreateAccountFailure> = .idle

        public init() {}
    }

    public enum Action: BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)

        @CasePathable
        public enum ViewAction {
            case cancelButtonTapped
            case createButtonTapped
        }

        @CasePathable
        public enum DelegateAction {
            case accountCreateSuccessfully
            case failedToCreateAccount(CreateAccountFailure)
        }

        @CasePathable
        public enum LocalAction {}
    }

    public init() {}

    @Dependency(\.AccountUseCase.createAccount) var createAccount
    @Dependency(\.mainQueue) var mainQueue

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            }
        }
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .none
        case .createButtonTapped:
            enum CancelId { case createAccount }

            state.createAccountProgress = .loading

            return createAccount(
                .bankAccount(
                    accountName: .init(initialValue: state.accountNameText),
                    icon: state.emoji,
                    balance: .init(state.balance),
                    currency: state.currency
                )
            )
            .debounce(id: CancelId.createAccount, for: .milliseconds(200), scheduler: mainQueue)
            .map(
                success: { _ in Action.delegate(.accountCreateSuccessfully) },
                failure: { Action.delegate(.failedToCreateAccount($0)) }
            )
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case .accountCreateSuccessfully:
            state.createAccountProgress = .loaded(.success(""))
            return .none
        case let .failedToCreateAccount(reason):
            state.createAccountProgress = .loaded(.failure(reason))
            return .none
        }
    }
}

public struct LengthConstrainedString: Value, Equatable {
    public var value: Result<String, LengthConstrainedValidationError> {
        validation.asResult
    }

    public var validation: Validated<String, LengthConstrainedValidationError> {
        validator.validate(valueString)
    }

    let validator: LengthConstrainedValidator

    public private(set) var valueString: String

    public init(lengthRange: ClosedRange<Int>, initialValue: String) {
        self.validator = LengthConstrainedValidator(range: lengthRange)
        self.valueString = initialValue
    }
}

public struct DefaultLengthConstrainedString: Value, Equatable {
    public var value: Result<String, LengthConstrainedValidationError> {
        validation.asResult
    }

    public var validation: Validated<String, LengthConstrainedValidationError> {
        validator.validate(valueString)
    }

    let validator = LengthConstrainedValidator(range: 0 ... 255)

    public private(set) var valueString: String

    public init(initialValue: String) {
        self.valueString = initialValue
    }
}

@CasePathable
public enum LengthConstrainedValidationError: LocalizedError, Equatable {
    case shorterThanMin(_ min: Int)
    case longerThanMax(_ max: Int)
}

public struct LengthConstrainedValidator: Validator {
    private let range: ClosedRange<Int>

    public init(range: ClosedRange<Int>) {
        self.range = range
    }

    public func validate(_ input: String) -> Validated<String, LengthConstrainedValidationError> {
        if range.lowerBound > input.count {
            return .invalid(input, .shorterThanMin(range.lowerBound))
        } else if range.upperBound < input.count {
            return .invalid(input, .longerThanMax(range.upperBound))
        }

        return .valid(input)
    }
}

// @propertyWrapper
// public struct Clamping    {
//    var value: String
//    let range: ClosedRange<Int>
//
//    public init(wrappedValue: Value, range: ClosedRange<Int>) {
//        self.range = range
//
//
//        let start = str.index(str.startIndex, offsetBy: 0)
//        let end = str.index(str.startIndex, offsetBy: 6)
//        let range = start..<end
//        let sub = str[start..<end]
//        str = String(sub)
//
//
//        value.ra
//        self.value = range.clamp(wrappedValue)
//    }
//
//    public var wrappedValue: String {
//        get { value }
//        set {
//            value = range.clamp(newValue)
//            if newValue.count >= minLength && input.count <= maxLength {
//            //            return input
//            //        } else {
//            //            return String(input.prefix(maxLength))
//            //        }
//
//        }
//    }
// }

// @propertyWrapper
// struct LimitedLengthString {
//    private var value: String = ""
//    private let minLength: Int
//    private let maxLength: Int
//
//    var wrappedValue: String {
//        get { value }
//        set { value = LimitedLengthString.validate(newValue, minLength: minLength, maxLength: maxLength) }
//    }
//
//    init(wrappedValue: String, minLength: Int, maxLength: Int) {
//        assert(minLength < maxLength, "minLength should be less than maxLength")
//        self.minLength = minLength
//        self.maxLength = maxLength
//        self.wrappedValue = LimitedLengthString.validate(wrappedValue, minLength: minLength, maxLength: maxLength)
//    }
//
//    private static func validate(_ input: String, minLength: Int, maxLength: Int) -> String {
//        if input.count >= minLength && input.count <= maxLength {
//            return input
//        } else {
//            return String(input.prefix(maxLength))
//        }
//    }
// }

// fileprivate extension ClosedRange {
//    func clamp(_ value : Bound) -> Bound {
//        return self.lowerBound > value ? self.lowerBound
//            : self.upperBound < value ? self.upperBound
//            : value
//    }
// }
