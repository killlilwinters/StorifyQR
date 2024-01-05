//
//  ContentView.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    static let imageConverter = ImageCoverter()
    @Environment(\.modelContext) var modelContext
    @Query private var storedItems: [StoredItem]
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(storedItems) { item in
                NavigationLink(value: item) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text(item.itemDescription ?? "No description")
                        }
                        Spacer()
                        Image(uiImage: ContentView.imageConverter.convertImage(ciImage: item.qrCode))
                            .resizable()
                            .interpolation(.none)
                            .frame(width: 50, height: 50)
                            .scaledToFit()
                    }
                }
            }
            .navigationDestination(for: StoredItem.self, destination: { item in
                ItemDetailView(item: item)
            })
            .navigationTitle("StorifyQR")
            .toolbar {
                NavigationLink {
                    NewItemView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
