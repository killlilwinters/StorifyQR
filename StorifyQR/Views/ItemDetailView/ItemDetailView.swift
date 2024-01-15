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
    
    let viewModel: ItemDetailViewModel
    
    var body: some View {
        Background {
            ScrollView(.vertical) {
                VStack {
                    Rectangle()
                        .frame(height: 250)
                        .foregroundStyle(.link)
                        .overlay (
                            Image(systemName: "shippingbox.fill")
                                .font(.system(size: 100))
                        )
                    ScrollView(.horizontal) {
                        ActionButtons()
                    }
                    VStack {
                        Text("Tags:")
                            .font(.system(.headline))
                            .padding(.horizontal)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.item.tags) { tag in
                                    Text(tag.title)
                                        .padding(10)
                                        .foregroundStyle(.white)
                                        .background(tag.colorComponent.getColor.gradient)
                                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
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
                        Text(viewModel.item.itemDescription ?? "No description")
                    }
                    .modifier(ContentPad())
                    .padding()
                    if viewModel.item.location != nil {
                        Coordinate2DMapView(coordinate2D: viewModel.item.location!)
                    }
                    Text("QR Code:")
                    if viewModel.isShowingQR {
                        let image = viewModel.shareQR()
                        ShareLink(item: image, preview: SharePreview("QRCode for \(viewModel.item.name)", image: image)) {
                            image
                                .resizable()
                                .scaledToFit()
                                .modifier(ContentPad())
                                .padding()
                                .containerRelativeFrame(.horizontal, { width, axis in
                                    width * 0.6
                                })
                        }
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        .popoverTip(viewModel.qrTip)
                        .simultaneousGesture(TapGesture().onEnded() {
                            viewModel.qrTip.invalidate(reason: .actionPerformed)
                        })
                        
                    }
                    Button(viewModel.isShowingQR ? "Hide" : "Show") {
                        withAnimation(.bouncy) {
                            viewModel.isShowingQR.toggle()
                        }
                    }
                    .buttonStyle(.bordered)
                    .clipShape(.capsule)
                    Text(viewModel.getDate())
                        .foregroundStyle(.secondary)
                }
                .navigationTitle(viewModel.item.name)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    init(item: StoredItem) {
        self.viewModel = ItemDetailViewModel(item: item)
    }
    
}

#Preview {
    let preview = PreviewContainer([StoredItem.self])
    return ItemDetailView(item: PreviewContainer.item)
        .modelContainer(preview.container)
}
