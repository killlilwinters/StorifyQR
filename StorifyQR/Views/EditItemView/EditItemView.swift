//
//  EditItemView.swift
//  StorifyQR
//
//  Created by Maks Winters on 31.01.2024.
//
// https://stackoverflow.com/questions/57244713/get-index-in-foreach-in-swiftui
//

import SwiftUI

import SwiftUI
import PhotosUI

struct EditItemView: View {
    @Environment(\.dismiss) var dismiss
//    @Environment(MapViewModel.self) var mapViewModel
    @Bindable var viewModel: EditItemViewModel
    @Namespace var mapID
    
    var body: some View {
        Background {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        // Picture view, picture selector
                        VStack {
                            if viewModel.image != nil {
                                viewModel.image!
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                EmptyPhotoView()
                            }
                            PhotosPicker(selection: $viewModel.pickerItem, matching: .images) {
                                SelectPhotoButtonView()
                            }
                                .buttonStyle(.plain)
                                .clipShape(.capsule)
                                .padding(.top)
                                .onChange(of: viewModel.pickerItem, viewModel.loadImage)
                        }
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
                                        viewModel.isShowingSheet.toggle()
                                        print("Toggled sheet")
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
                        .sheet(isPresented: $viewModel.isShowingSheet) {
                            AddTagView(classifierInstance: viewModel.classifier) { tag in
                                print("saveTo appending a Tag")
                                viewModel.addTagToItem(tag: tag)
                            }
                            .presentationDetents([.medium, .large])
                        }
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
                    viewModel.askToSave()
                } label: {
                    StyledButtonComponent(foregroundStyle: EditItemViewModel.saveButtonStyle, title: Text("Save changes"))
                        .containerRelativeFrame(.horizontal) { width, axis in
                            width * 0.7
                        }
                }
                .padding(.vertical)
            }
            .navigationTitle("Editing - \(viewModel.item.name)")
            .navigationBarTitleDisplayMode(.inline)
        }.onTapGesture {
            viewModel.endEditing()
        }
        .alert("Save changes to \"\(viewModel.name)\"?", isPresented: $viewModel.isShowingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                viewModel.saveChanges()
                dismiss()
            }
        }
    }
    
    init(item: StoredItem) {
        self.viewModel = EditItemViewModel(item: item)
    }
    
}

#Preview {
    StoredItemDataSource.shared.appendItem(StoredItem(id: UUID(), name: "Testing item", itemDescription: "This item is used for testing", location: nil))
    return EditItemView(item: StoredItemDataSource.shared.fetchItems().first!)
}
