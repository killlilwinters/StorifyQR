//
//  ContentView.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(Coordinator.self) var coordinator
    
    // Bindable property wrapper causes ContentView to re-render endlessly
    @State var viewModel = ContentViewModel()
    
    var body: some View {
        Background {
            ScrollView(.vertical) {
                VStack {
                    //  if viewModel.isSearching {
                    //       SearchBar(searchText: $viewModel.searchText)
                    //             .padding()
                    //  }
                    Tags

                    Items
                        .animation(reduceMotion ? .none : .bouncy(duration: 0.3), value: viewModel.storedItems)
                    
                    if viewModel.isShowingNoItemsForTagCUV {
                        ContentUnavailableView(
                            "No items",
                            systemImage: "tag.slash",
                            description: Text("There are no items associated with this tag.")
                        )
                    }
                    
                    if viewModel.isShowingNoItemsCUV {
                        ContentUnavailableView(
                            "No items",
                            systemImage: "shippingbox.circle.fill",
                            description: Text("Press \"+\" to add items")
                        )
                    }
                    
                    if viewModel.isShowingNothingFoundCUV {
                        ContentUnavailableView(
                            "Nothing found",
                            systemImage: "magnifyingglass",
                            description: Text("Try changing your search query.")
                        )
                    }
                    
                }
            }
            .onAppear {
                print("ContentView appeared")
                viewModel.fetchItems()
            }
            .navigationTitle("StorifyQR")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        coordinator.push(.newItemView)
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
            .alert("Import \"\(viewModel.importItem?.name ?? "")\"?", isPresented: $viewModel.importingAlert) {
                Button("Cancel", role: .cancel) { }
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
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            Button {
                coordinator.push(.scannerView)
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 25))
                            .foregroundStyle(.reversed)
                    }
            }
            .padding()
            .shadow(radius: 5)
        }
    }
    
    var Tags: some View {
        ScrollView(.horizontal) {
            HStack {
                
                InlineSearchBar(
                    isSearching: $viewModel.isSearching,
                    searchText: $viewModel.searchText
                )
                .padding(.leading)
                
                ForEach(viewModel.tags) { tag in
                    let isSelected = tag == viewModel.selectedTag
                    let trailingPadding: CGFloat = viewModel.tags.last == tag ? 15 : 0
                    
                    TagView(tag: tag)
                        .onTapGesture {
                            viewModel.filterTag(tag: tag)
                        }
                        .overlay (
                            Capsule()
                                .stroke(lineWidth: isSelected ? 3 : 0)
                        )
                        .padding(.horizontal, 1)
                        .padding(.vertical, 2)
                        .padding(.trailing, trailingPadding)
                    
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.vertical)
    }
    
    var Items: some View {
        ForEach(viewModel.filteredItems) { item in
            Button {
                coordinator.push(.detailView(item))
            } label: {
                LazyVStack {
                    ItemView(
                        image: item.image,
                        name: item.name,
                        itemDescription: item.itemDescription
                    )
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    // https://forums.developer.apple.com/forums/thread/661669
    
    // Appending a mock item
    let item = StoredItem(
        id: UUID(),
        name: "Testing item",
        itemDescription: "This item is used for testing",
        location: nil
    )
    StoredItemDataSource.shared.appendItem(item)
    
    // Appending a mock tag
    let tag = Tag(
        title: "Test",
        isMLSuggested: false,
        tagColor: .tagOrange
    )
    TagDataSource.shared.appendItem(tag)
    
    return ContentView()
        .environment(Coordinator())
}
