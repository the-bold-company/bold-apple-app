//
//  FireShortcuts.swift
//  Fire
//
//  Created by Hien Tran on 14/02/2024.
//

import AppIntents
import Intents

struct FireShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: TransactionRecordingIntent(),
            phrases: [
                "Record a \(.applicationName) transaction",
                "\(.applicationName) transaction",
            ],
            shortTitle: "Record a transaction",
            systemImageName: "arrow.forward"
        )
    }
}
