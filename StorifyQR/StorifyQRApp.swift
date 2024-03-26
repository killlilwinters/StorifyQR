//
//  StorifyQRApp.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//
// https://www.youtube.com/watch?v=2D05dGo3jB4
//

import SwiftUI
import TipKit

@main
struct StorifyQRApp: App {
    
    @State private var mapViewModel = MapViewModel(editingLocation: nil)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    try? Tips.configure([
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
        .environment(mapViewModel)
//        .modelContainer(for: StoredItem.self) this is the cause of Sheet closing automatically when using MVVM SwiftData implementation.
    }
}
