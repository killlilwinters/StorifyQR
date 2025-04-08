//
//  ContentView.swift
//  StorifyQR
//
//  Created by Maks Winters on 09.04.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedItem: StoredItem?
    @Environment(Coordinator.self) var coordinator
    
    var body: some View {
        NavigationSplitView {
            ItemListView(selectedItem: $selectedItem)
                .environment(coordinator)
        } detail: {
            if let selectedItem {
                ItemDetailView(item: selectedItem)
            } else {
                ContentUnavailableView("Select an item", systemImage: "shippingbox.fill")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Coordinator())
}
