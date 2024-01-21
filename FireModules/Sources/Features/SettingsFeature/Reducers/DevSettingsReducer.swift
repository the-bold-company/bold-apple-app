//
//  DevSettingsReducer.swift
//
//
//  Created by Hien Tran on 20/01/2024.
//

import ComposableArchitecture
import DevSettingsUseCases
import SharedModels

@Reducer
public struct DevSettingsReducer {
    public init() {}

    public struct State: Equatable {
        public init() {
            @Dependency(\.devSettings) var devSettingsClient
            self.devSettings = devSettingsClient.get()
        }

        @BindingState public var devSettings: DevSettings = .init()
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case updateDevSettings(DevSettings)
    }

    @Dependency(\.devSettings) var devSettings
    @Dependency(\.mainQueue) var mainQueue

    public var body: some ReducerOf<Self> {
        CombineReducers {
            BindingReducer()
                .onChange(of: \.devSettings.credentials) { _, _ in
                    Reduce { _, _ in
                        return .none
                    }
                }

            Reduce { _, action in
                switch action {
                case let .updateDevSettings(newSettings):
                    return .run { _ in
                        await devSettings.set(newSettings)
                    }
                case .binding:
                    return .none
                }
            }
        }
        .onChange(of: \.devSettings) { _, newSettings in
            Reduce { _, _ in
                enum CancelID { case saveDebounce }

                return .run { _ in await devSettings.set(newSettings) }
                    .debounce(id: CancelID.saveDebounce, for: .seconds(0.5), scheduler: mainQueue)
            }
        }
    }
}
