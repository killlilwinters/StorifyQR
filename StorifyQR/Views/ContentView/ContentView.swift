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
            Background {
                ScrollView(.vertical) {
                    items
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
                    viewModel.processImport(result: result)
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
    
    var items: some View {
        VStack {
            ForEach(viewModel.storedItems) { item in
                NavigationLink(value: item) {
                    LazyVStack {
                        HStack {
                            let image = viewModel.getImage(item: item)
                            if image != nil {
                                image!
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .scaledToFill()
                                    .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 25, bottomLeading: 25, bottomTrailing: 0, topTrailing: 0)))
                            } else {
                                Image(systemName: "shippingbox")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding()
                            }
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .bold()
                                let append = item.itemDescription?.count ?? 0 > 20
                                Text(item.itemDescription?.prefix(20).appending(
                                    append ? "..." : ""
                                ) ?? "Do description")
                            }
                            .padding(.horizontal)
                            Spacer()
                        }
                        .modifier(ContentPad(enablePadding: false))
                        .padding(.horizontal)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
// https://forums.developer.apple.com/forums/thread/661669
    StoredItemDataSource.shared.appendItem(item: StoredItem(name: "Testing item", itemDescription: "This item is used for testing", location: nil))
    return ContentView()
}
