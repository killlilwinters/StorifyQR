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
                    tags
                        .padding()
                    items
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
    
    var tags: some View {
        ScrollView(.horizontal) {
            HStack {
                Capsule()
                    .tint(.primary)
                    .overlay (
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.reversed)
                                .onTapGesture {
                                    withOptionalAnimation {
                                        viewModel.isSearching.toggle()
                                    }
                                }
                            if viewModel.isSearching {
                                TextField("", text: $viewModel.searchText)
                                    .foregroundStyle(.reversed)
                                    .placeholder(when: viewModel.searchText.isEmpty) {
                                        Text("Search...").foregroundColor(.reversed)
                                    }
                            }
                        }
                            .padding(.horizontal)
                    )
                    .frame(width: viewModel.isSearching ? 200 : 45, height: 45)
                ForEach(viewModel.tags) { tag in
                    let isSelected = tag == viewModel.selectedTag
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
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    var items: some View {
        ForEach(viewModel.filteredItems) { item in
            Button {
                coordinator.push(.detailView(item))
            } label: {
                LazyVStack {
                    HStack {
                        let image = viewModel.getImage(item: item)
                        if image != nil {
                            image!
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 25, bottomLeading: 25, bottomTrailing: 0, topTrailing: 0)))
                        } else {
                            HStack(spacing: 0) {
                                Image(systemName: "shippingbox")
                                    .font(.system(size: 50))
                                    .frame(width: 100, height: 100)
                                Rectangle()
                                    .frame(width: 1, height: 100)
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .bold()
                            Text(item.itemDescription.limit(limit: 20))
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

#Preview {
    // https://forums.developer.apple.com/forums/thread/661669
    StoredItemDataSource.shared.appendItem(StoredItem(id: UUID(), name: "Testing item", itemDescription: "This item is used for testing", location: nil))
    return ContentView()
        .environment(Coordinator())
}
