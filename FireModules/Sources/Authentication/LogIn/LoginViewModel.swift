//
//  LoginViewModel.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import Combine
import Foundation
import Networking

final class LoginViewModel: ObservableObject {
    let authService = AuthAPIService()

    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isFormValid = false
    @Published var logInState: LoginState = .pristine

    private var loginEvent = PassthroughSubject<Void, Never>()

    private var subscriptions = Set<AnyCancellable>()

    private var loginCancellable: AnyCancellable?

    init() {
        let typedEmail = $email
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .share()

        let typedPassword = $password
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .share()

        // TODO: Add email verification rules
        let typeEmailValid = typedEmail
            .map { $0.count >= 3 }
            .share()

        // TODO: Add password verification rules
        let typedPasswordValid = typedPassword
            .map { !$0.isEmpty }
            .share()

        Publishers.CombineLatest(typeEmailValid, typedPasswordValid)
            .map { validUsername, validPassword in
                return validUsername && validPassword
            }
            .receive(on: RunLoop.main)
            .assign(to: &$isFormValid)

        loginEvent
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.logIn()
            })
            .store(in: &subscriptions)
    }

    func onLoginButtonTapped() {
        loginEvent.send()
    }

    private func cancelLoginIfNeeded() {
        logInState = .pristine
        loginCancellable?.cancel()
    }

    private func logIn() {
        cancelLoginIfNeeded()

        logInState = .loading

        loginCancellable = authService
            .login(email: email, password: password)
            .sink { [weak self] result in
                self?.logInState = .loaded(result)
            }
    }
}

extension LoginViewModel {
    enum LoginState: Equatable {
        case pristine
        case loading
        case loaded(Result<LoginResponse, NetworkError>)

        var loadedResult: LoginResponse? {
            switch self {
            case let .loaded(result):
                return try? result.get()
            default:
                return nil
            }
        }

        var loadedError: NetworkError? {
            switch self {
            case let .loaded(result):
                if case let .failure(err) = result {
                    return err
                }
                return nil
            default:
                return nil
            }
        }

        static func == (lhs: LoginViewModel.LoginState, rhs: LoginViewModel.LoginState) -> Bool {
            switch (lhs, rhs) {
            case (.pristine, .pristine):
                return true
            case (.loading, .loading):
                return true
            case (.loaded, .loaded):
                return true
            default:
                return false
            }
        }
    }
}
