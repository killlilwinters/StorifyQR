//
//  StorifyQRApp.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//
// https://www.youtube.com/watch?v=2D05dGo3jB4
//
// https://www.youtube.com/watch?v=kbgNL7VrQPo
//
// https://stackoverflow.com/questions/24591167/how-to-get-current-language-code-with-swift
//

import SwiftUI
import TipKit

@main
struct StorifyQRApp: App {
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .task {
                    configureTips()
                }
        }
//        .modelContainer(for: StoredItem.self) this is the cause of Sheet closing automatically when using MVVM SwiftData implementation.
    }
    
    func configureTips() {
        try? Tips.configure([
            .datastoreLocation(.applicationDefault)
        ])
    }
    
}
