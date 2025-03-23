//
//  CoordinatorView.swift
//  StorifyQR
//
//  Created by Maks Winters on 23.03.2025.
//

import SwiftUI

struct CoordinatorView: View {
    
    @Bindable var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ContentView()
                .environment(coordinator)
                .navigationDestination(for: ViewDestination.self) { destination in
                    coordinator.build(destination: destination)
                }
        }
    }
}

#Preview {
    CoordinatorView()
}
