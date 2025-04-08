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
                    
                    TagsCarrousel(
                        isSearching:   $viewModel.isSearching,
                        searchText:    $viewModel.searchText,
                        selectedTag:   $viewModel.selectedTag,
                        tags:          viewModel.tags,
                        performFilter: viewModel.filterTag(tag:)
                    )

                    Items
                        .animation(reduceMotion ? .none : .bouncy(duration: 0.3), value: viewModel.storedItems)
                    
                    UnavailableView
                    
                }
            }
            .onAppear { viewModel.fetchItems() }
            .toolbar { ToolBarItems }
            .importAndAlertModifiers(viewModel: viewModel)
            .simpleErrorAlert(
                message: viewModel.errorMessage,
                isPresented: $viewModel.isPresentingError
            )
        }
        .navigationTitle("StorifyQR")
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            FloatingButton
        }
    }
    
    // MARK: UnavailableView
    var UnavailableView: some View {
        if viewModel.isShowingNoItemsForTagCUV {
            return ContentUnavailableView(
                "No items",
                systemImage: "tag.slash",
                description: Text("There are no items associated with this tag.")
            )
        }
        
        if viewModel.isShowingNoItemsCUV {
            return ContentUnavailableView(
                "No items",
                systemImage: "shippingbox.circle.fill",
                description: Text("Press \"+\" to add items")
            )
        }
        
        if viewModel.isShowingNothingFoundCUV {
            return ContentUnavailableView(
                "Nothing found",
                systemImage: "magnifyingglass",
                description: Text("Try changing your search query.")
            )
        }
        
        return ContentUnavailableView("An error occured", systemImage: "exclamationmark.triangle")
    }
    
    // MARK: FloatingButton
    var FloatingButton: some View {
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
    
    // MARK: ToolBarItems
    @ToolbarContentBuilder
    var ToolBarItems: some ToolbarContent {
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
    
    // MARK: Items
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

// MARK: - Import and Alert Modifiers
private extension View {
    func importAndAlertModifiers(viewModel: ContentViewModel) -> some View {
        
        // Show importing screen
        let importingData = Binding {
            viewModel.importingData
        } set: { value in
            viewModel.importingData = value
        }
        
        // Show import error
        let importingAlert = Binding {
            viewModel.importingAlert
        } set: { value in
            viewModel.importingAlert = value
        }

        return self
            .fileImporter(isPresented: importingData, allowedContentTypes: [.sqrExportType]) { result in
                viewModel.processImport(result: result)
            }
            .alert("Import \"\(viewModel.importItem?.name ?? "")\"?", isPresented: importingAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Save") {
                    viewModel.saveItem()
                }
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
