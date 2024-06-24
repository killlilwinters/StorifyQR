//
//  ItemDetailView.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//
//https://stackoverflow.com/questions/73781043/swiftui-4-0-how-to-know-if-sharelink-has-been-shared-successfully
//

import SwiftUI
import SwiftData
import MapKit

struct ItemDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: ItemDetailViewModel
    @Namespace var qrCodeID
    
    var body: some View {
        Background {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack {
                        if viewModel.image != nil {
                            viewModel.image!
                                .resizable()
                                .scaledToFit()
                        } else {
                            EmptyPhotoView()
                        }
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            actionButtons
                        } else {
                            ScrollView(.horizontal) {
                                actionButtons
                            }
                            .scrollIndicators(.hidden)
                        }
                        VStack {
                            Text("Tags:")
                                .font(.system(.headline))
                                .padding(.horizontal)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(viewModel.item.tags) { tag in
                                        TagView(tag: tag)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                        .onAppear {
                            print(viewModel.item.tags)
                        }
                        .modifier(ContentPad())
                        .padding(.top)
                        .padding(.horizontal)
                        VStack {
                            Text("Description:")
                                .foregroundStyle(.secondary)
                            Text(viewModel.item.itemDescription)
                        }
                        .modifier(ContentPad())
                        .padding()
                        if viewModel.item.location != nil {
                            Coordinate2DMapView(coordinate2D: viewModel.item.location!)
                        }
                        Text("QR Code:")
                        if viewModel.isShowingQR {
                            let image = viewModel.getQR()
                            
                            let preview = SharePreview("QR Code for \(viewModel.item.name)",
                                                       image: image)
                            
                            ShareLink(item: viewModel.shareQR(), preview: preview) {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .modifier(ContentPad())
                                    .containerRelativeFrame(.horizontal, { width, axis in
                                        width * 0.5
                                    })
                            }
                            .transition(.asymmetric(insertion: .scale, removal: .opacity))
                            .popoverTip(viewModel.qrTip)
                            .simultaneousGesture(TapGesture().onEnded() {
                                viewModel.qrTip.invalidate(reason: .actionPerformed)
                            })
                            
                        }
                        Button(viewModel.isShowingQR ? "Hide" : "Show") {
                            withOptionalAnimation(.bouncy) {
                                viewModel.isShowingQR.toggle()
                            }
                        }
                        .id(qrCodeID)
                        .buttonStyle(.bordered)
                        .clipShape(.capsule)
                        .simultaneousGesture(TapGesture().onEnded() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withOptionalAnimation {
                                    proxy.scrollTo(qrCodeID)
                                }
                            }
                        })
                        Text(viewModel.getDate())
                            .foregroundStyle(.secondary)
                    }
                    .alert("Are you sure you want to delete \"\(viewModel.item.name)\"?", isPresented: $viewModel.isShowingAlert, actions: {
                        Button("Delete", role: .destructive) {
                            viewModel.deleteCurrentItem()
                            dismiss()
                        }
                    })
                    .navigationTitle(viewModel.item.name)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
    
    init(item: StoredItem) {
        self.viewModel = ItemDetailViewModel(item: item)
    }
    
}

#Preview {
    StoredItemDataSource.shared.appendItem(StoredItem(id: UUID(), name: "Testing item", itemDescription: "This item is used for testing", location: nil))
    return ItemDetailView(item: StoredItemDataSource.shared.fetchItems().first!)
}
