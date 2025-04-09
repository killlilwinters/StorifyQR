//
//  ContentView.swift
//  StorifyQR
//
//  Created by Maks Winters on 09.04.2025.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var coordinator = Coordinator()
    
    @State private var selectedItem: StoredItem?
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            NavigationSplitView {
                ItemListView(selectedItem: $selectedItem)
                    .environment(coordinator)
            } detail: {
                CoordinatorView(selectedItem: $selectedItem)
                    .environment(coordinator)
            }
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            CoordinatorView(selectedItem: .constant(nil))
                .environment(coordinator)
        }
    }
}

#Preview {
    ContentView()
        .environment(Coordinator())
}
