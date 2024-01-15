//
//  ContentView.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Bindable var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List(viewModel.storedItems) { item in
                NavigationLink(value: item) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text(item.itemDescription ?? "No description")
                        }
                        Spacer()
                        Image(uiImage: ContentViewModel.imageConverter.convertImage(ciImage: item.qrCode))
                            .resizable()
                            .interpolation(.none)
                            .frame(width: 50, height: 50)
                            .scaledToFit()
                    }
                }
            }
            .onAppear {
                viewModel.fetchItems()
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
