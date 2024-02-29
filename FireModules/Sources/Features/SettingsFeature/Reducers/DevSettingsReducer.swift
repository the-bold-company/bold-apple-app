//
//  DevSettingsReducer.swift
//
//
//  Created by Hien Tran on 20/01/2024.
//

import ComposableArchitecture
import DevSettingsUseCase
import Factory
import SharedModels

@Reducer
public struct DevSettingsReducer {
    public struct State: Equatable {
        public init() {
            @Injected(\SettingsFeatureContainer.devSettingsUseCase) var devSettings: DevSettingsUseCase!
            self.settings = devSettings.get()
        }

        @BindingState public var settings: DevSettings = .init()
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case updateDevSettings(DevSettings)
    }

    @Dependency(\.mainQueue) var mainQueue
    let devSettingsUseCase: DevSettingsUseCase

    public init(devSettingsUseCase: DevSettingsUseCase) {
        self.devSettingsUseCase = devSettingsUseCase
    }

    public var body: some ReducerOf<Self> {
        CombineReducers {
            BindingReducer()
                .onChange(of: \.settings.credentials) { _, _ in
                    Reduce { _, _ in
                        return .none
                    }
                }

            Reduce { _, action in
                switch action {
                case let .updateDevSettings(newSettings):
                    return .run { _ in
                        await devSettingsUseCase.set(newSettings)
                    }
                case .binding:
                    return .none
                }
            }
        }
        .onChange(of: \.settings) { _, newSettings in
            Reduce { _, _ in
                enum CancelID { case saveDebounce }

                return .run { _ in await devSettingsUseCase.set(newSettings) }
                    .debounce(id: CancelID.saveDebounce, for: .seconds(0.5), scheduler: mainQueue)
            }
        }
    }
}
