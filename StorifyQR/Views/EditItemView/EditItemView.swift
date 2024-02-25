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
                            PhotosPicker("Select a photo", selection: $viewModel.pickerItem)
                                .buttonStyle(.bordered)
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
                                        HStack {
                                            Text(tag.title)
                                            Button {
                                                viewModel.removeTag(at: index)
                                                
                                            } label: {
                                                Image(systemName: "xmark")
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .padding(10)
                                        .foregroundStyle(.white)
                                        .background(tag.colorComponent.getColor.gradient)
                                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
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
                            AddTagView { tag in
                                print("saveTo appending a Tag")
                                viewModel.tags.append(tag)
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
                        }
                        .modifier(ContentPad())
                        .padding(.horizontal)
                        viewModel.mapView // MapView
                            .id(mapID)
                            .onChange(of: viewModel.mapView.viewModel.isIncludingLocation) { oldValue, newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withOptionalAnimation {
                                        proxy.scrollTo(mapID)
                                    }
                                }
                            }
                    }
                }
            }
            .onAppear(perform: viewModel.checkLocation)
            // Bottom save floating button
            .safeAreaInset(edge: .bottom, alignment: .center) {
                Button {
                    viewModel.askToSave()
                } label: {
                    StyledButtonComponent(title: "Save changes", foregroundStyle: EditItemViewModel.saveButtonStyle)
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
    StoredItemDataSource.shared.appendItem(item: StoredItem(name: "Testing item", itemDescription: "This item is used for testing", location: nil))
    return EditItemView(item: StoredItemDataSource.shared.fetchItems().first!)
}
