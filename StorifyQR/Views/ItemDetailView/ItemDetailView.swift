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
                        Text("Description:")
                            .foregroundStyle(.secondary)
                        Text(viewModel.item.itemDescription ?? "No description")
                    }
                    .modifier(ContentPad())
                    .padding()
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredItem.self, configurations: config)
    let item = StoredItem(name: "StoredItem", itemDescription: "Important: If you attempt to create a model object without first having created a container for that object, your preview will crash. If you do all that and don't use the modelContainer() modifier to send your container into SwiftUI, running any code using the modelContext environment key will also crash your preview.")
    return ItemDetailView(item: item)
        .modelContainer(container)
}
