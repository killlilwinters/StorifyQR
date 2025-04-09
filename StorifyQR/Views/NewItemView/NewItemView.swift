//
//  NewItemView.swift
//  StorifyQR
//
//  Created by Maks Winters on 04.01.2024.
//
// https://stackoverflow.com/questions/69965379/swiftui-how-to-prevent-keyboard-in-a-sheet-to-push-up-my-main-ui
//
// https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
//
// https://www.youtube.com/watch?v=83RhhYeybgQ
//

import SwiftUI
import PhotosUI

struct NewItemView: View {
 
    @Environment(Coordinator.self) var coordinator
    @State var viewModel = NewItemViewModel()
    @Namespace var mapID
    
    var body: some View {
        Background {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        // Picture view, picture selector
                        PhotosPickerView(
                            image: $viewModel.image,
                            pickerItem: $viewModel.pickerItem,
                            loadImage: viewModel.loadImage
                        )
                        // Tags
                        VStack {
                            Text("Tags:")
                                .font(.system(.headline))
                                .padding(.horizontal)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(Array(viewModel.tags.enumerated()), id: \.offset) { index, tag in
                                        DeletableTagView(tag: tag) {
                                            viewModel.removeTag(at: index)
                                        }
                                    }
                                    Button {
                                        coordinator.push(.addTagView(viewModel.classifier) { tag in
                                            print("saveTo appending a Tag")
                                            viewModel.addTagToItem(tag: tag)
                                        })
                                    } label: {
                                        Image(systemName: "plus")
                                            .frame(width: 25, height: 25)
                                    }
                                    .buttonStyle(.bordered)
                                    .buttonBorderShape(.circle)
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                        .modifier(ContentPad())
                        .padding(.horizontal)
                        // Name TextField
                        VStack {
                            Text("Name:")
                                .font(.system(.headline))
                                .padding(.horizontal)
                            TextField("Enter your item's name", text: $viewModel.name)
                                .frame(height: 50)
                                .onChange(of: viewModel.name) {
                                    viewModel.limitName()
                                }
                            if !viewModel.name.isEmpty {
                                HStack {
                                    Spacer()
                                    Text(viewModel.nameCharactersLeft)
                                }
                            }
                            if viewModel.isShowingNameWarning {
                                Text("Name is required to proceed!")
                                    .foregroundStyle(.red)
                                    .padding(.horizontal)
                            }
                        }
                        .modifier(ContentPad())
                        .padding(.horizontal)
                        // Description TextField
                        VStack {
                            Text("Description:")
                                .font(.system(.headline))
                                .padding(.horizontal)
                            TextField("Enter your item's name", text: $viewModel.itemDescription, axis: .vertical)
                                .frame(height: 100)
                                .lineLimit(2...5)
                                .onChange(of: viewModel.itemDescription) {
                                    viewModel.limitDescription()
                                }
                            if !viewModel.itemDescription.isEmpty {
                                HStack {
                                    Spacer()
                                    Text(viewModel.descCharactersLeft)
                                }
                            }
                        }
                        .modifier(ContentPad())
                        .padding(.horizontal)
                        viewModel.mapView // MapView
                            .id(mapID)
                            .onChange(of: viewModel.mapView.isIncludingLocation) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withOptionalAnimation {
                                        proxy.scrollTo(mapID)
                                    }
                                }
                            }
                    }
                }
            }
            // Bottom save floating button
            .safeAreaInset(edge: .bottom, alignment: .center) {
                Button {
                    #warning("Implement ListView update upon save")
                    viewModel.askToSave()
                } label: {
                    StyledButtonComponent(foregroundStyle: Color.createItemButton.gradient, title: Text("Create item"))
                        .containerRelativeFrame(.horizontal) { width, axis in
                            width * 0.7
                        }
                }
                .padding(.vertical)
            }
            .navigationTitle("Add new item")
            .navigationBarTitleDisplayMode(.inline)
        }.onTapGesture {
            viewModel.endEditing()
        }
        .alert("Save \"\(viewModel.name)\"?", isPresented: $viewModel.isShowingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                viewModel.saveToContext()
                coordinator.pop()
            }
        }
        .alert("Can't perform this action.", isPresented: $viewModel.isShowingTagAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You can only add one ML-generated tag to your item, try removing the previous one first.")
        }
    }
}

#Preview {
    StoredItemDataSource.shared.appendItem(StoredItem(id: UUID(), name: "Testing item", itemDescription: "This item is used for testing", location: nil))
    return NewItemView()
        .environment(Coordinator())
}
