//
//  QRItemView.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.06.2024.
//

import SwiftUI

struct QRItemView: View {
    
    @Bindable var viewModel: QRItemViewModel
    
    @State private var endpoint1: UnitPoint = .bottomLeading
    @State private var endpoint2: UnitPoint = .topTrailing
    
    var body: some View {
        GeometryReader { proxy in
            let proxyWidth = proxy.size.width
            HStack {
                if let photo = viewModel.item.photo {
                    Image(data: photo)!
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxyWidth / 4, height: proxyWidth / 4)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.contentPad)
                        .frame(width: proxyWidth / 4, height: proxyWidth / 4)
                        .overlay {
                            Image(systemName: "shippingbox.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(
                                    LinearGradient(colors: [.blue, .yellow], startPoint: endpoint1, endPoint: endpoint2)
                                )
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                                        endpoint1 = .topLeading
                                        endpoint2 = .bottomTrailing
                                    }
                                }
                        }
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.item.name.limit(limit: 15))
                        .font(.title)
                    HStack {
                        Button {
                            viewModel.isShowingAlert.toggle()
                        } label: {
                            Capsule()
                                .foregroundStyle(.tagRed)
                                .containerRelativeFrame(.vertical) { height, axis in
                                    height * 0.06
                                }
                                .overlay {
                                    Text("Delete")
                                }
                        }
                        .alert("Are you sure you want to delete \"\(viewModel.item.name)\"?", isPresented: $viewModel.isShowingAlert, actions: {
                            Button("Delete", role: .destructive) {
                                viewModel.removeCurrentItem(viewModel.item)
                            }
                        })
                        NavigationLink {
                            ItemDetailView(item: viewModel.item)
                        } label: {
                            Capsule()
                                .foregroundStyle(.tagBlue)
                                .containerRelativeFrame(.vertical) { height, axis in
                                    height * 0.06
                                }
                                .overlay {
                                    Text("More >")
                                }
                        }
                    }
                    .buttonStyle(.plain)
                }
                .containerRelativeFrame(.horizontal) { width, axis in
                    width * 0.5
                }
                .padding(.leading)
            }
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
    }
    
    init(
        item: StoredItem,
        removeCurrentItem: @escaping (StoredItem) -> Void
    ) {
        self.viewModel = QRItemViewModel(item: item, removeCurrentItem: removeCurrentItem)
    }
    
}

#Preview {
    StoredItemDataSource.shared.appendItem(StoredItem(name: "Testing item, additional text", itemDescription: "This item is used for testing", location: nil))
    return QRItemView(item: StoredItemDataSource.shared.fetchItems().first!, removeCurrentItem: { _ in })
}
