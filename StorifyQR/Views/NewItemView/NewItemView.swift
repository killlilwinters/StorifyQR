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

// TODO: Clean up the code

import SwiftUI
import PhotosUI

struct NewItemView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel = NewItemViewModel()
    
    var body: some View {
        Background {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack {
                            if viewModel.image != nil {
                                viewModel.image!
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            } else {
                                Image(systemName: "shippingbox.fill")
                                    .foregroundStyle(.gray)
                                    .background(.yellow)
                                    .font(.system(size: 100))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .padding(.vertical)
                            }
                            PhotosPicker("Select a photo", selection: $viewModel.pickerItem)
                                .buttonStyle(.bordered)
                                .clipShape(.capsule)
                                .padding(.top)
                                .onChange(of: viewModel.pickerItem) { oldValue, newValue in
                                    viewModel.loadImage()
                                }
                            Spacer()
                        }
                        .modifier(ContentPad())
                        .padding(.horizontal)
                        VStack {
                            Text("Tags:")
                                .font(.system(.headline))
                                .padding(.horizontal)
                            ScrollView(.horizontal) {
                                HStack {
                                    Text("No photo")
                                        .padding(10)
                                        .foregroundStyle(.white)
                                        .background(.blue.gradient)
                                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                    Button {
                                        // add a tag
                                    } label: {
                                        Image(systemName: "plus")
                                            .frame(width: 25, height: 25)
                                    }
                                    .buttonStyle(.bordered)
                                    .buttonBorderShape(.circle)
                                }
                            }
                        }
                        .modifier(ContentPad())
                        .padding(.horizontal)
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
                        VStack {
                            Text("Description:")
                                .font(.system(.headline))
                                .padding(.horizontal)
                            TextField("Enter your item's name", text: $viewModel.itemDescription, axis: .vertical)
                                .frame(height: 50)
                                .lineLimit(2...5)
                        }
                        .modifier(ContentPad())
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                .navigationTitle("Add new item")
                .navigationBarTitleDisplayMode(.inline)
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                viewModel.askToSave()
                            } label: {
                                SaveButton()
                            }
                            Spacer()
                        }
                    }
                }
                .ignoresSafeArea(.keyboard)
                .alert("Save \(viewModel.name)?", isPresented: $viewModel.isShowingAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Save") {
                        viewModel.saveToContext()
                        dismiss()
                    }
                }
            }
        }.onTapGesture {
            viewModel.endEditing()
        }
    }
}

struct SaveButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(LinearGradient(colors: [.blue, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing))
            .overlay (
                Text("Save")
                    .font(.headline)
                    .foregroundStyle(.white)
            )
            .frame(height: 50)
            .containerRelativeFrame(.horizontal) { width, axis in
                width * 0.7
            }
            .padding()
    }
}

#Preview {
    NewItemView()
}
