//
//  EditItemView.swift
//  StorifyQR
//
//  Created by Maks Winters on 31.01.2024.
//

import SwiftUI

import SwiftUI
import PhotosUI

struct EditItemView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: EditItemViewModel
    
    var body: some View {
        Background {
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
                            .onChange(of: viewModel.pickerItem) { oldValue, newValue in
                                viewModel.loadImage()
                            }
                    }
// Tags
                    VStack {
                        Text("Tags:")
                            .font(.system(.headline))
                            .padding(.horizontal)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.tags) { tag in
                                    Text(tag.title)
                                        .padding(10)
                                        .foregroundStyle(.white)
                                        .background(tag.colorComponent.getColor.gradient)
                                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                }
                                .onChange(of: viewModel.tags) { oldValue, newValue in
                                    print("Received value \(newValue.last?.title ?? "Idk")")
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
                }
            }
            .onAppear(perform: viewModel.preloadValues)
// Bottom save floating button
            .safeAreaInset(edge: .bottom, alignment: .center) {
                Button {
                    viewModel.saveChanges()
                    dismiss()
                } label: {
                    StyledButtonComponent(title: "Save changes", foregroundStyle: NewItemViewModel.saveButtonStyle)
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
        .alert("Save \(viewModel.name)?", isPresented: $viewModel.isShowingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                dismiss()
            }
        }
    }
    
    init(item: StoredItem) {
        self.viewModel = EditItemViewModel(item: item)
    }
    
}

#Preview {
    let preview = PreviewContainer([StoredItem.self])
    return EditItemView(item: PreviewContainer.item)
        .modelContainer(preview.container)
}
