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
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        NewItemView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Import", systemImage: "square.and.arrow.down") {
                        viewModel.importingData.toggle()
                    }
                }
            }
            .fileImporter(isPresented: $viewModel.importingData, allowedContentTypes: [.sqrExportType]) { result in
                switch result {
                case .success(let success):
                    viewModel.saveImport(success)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
            .alert("Import \(viewModel.importItem?.name ?? "")?", isPresented: $viewModel.importingAlert) {
                Button("Cancel") { }
                Button("Save") {
                    viewModel.saveItem()
                }
            }
            .alert("There was an error", isPresented: $viewModel.errorAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }

        }
    }
}

#Preview {
    ContentView()
}
