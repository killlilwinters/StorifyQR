//
//  StorifyQRApp.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//

import SwiftUI
import TipKit

@main
struct StorifyQRApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    try? Tips.configure([
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
//        .modelContainer(for: StoredItem.self) this is the cause of Sheet closing automatically when using MVVM SwiftData implementation.
    }
}
