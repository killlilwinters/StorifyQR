//
//  QRItemView.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.06.2024.
//

import SwiftUI

struct QRItemView: View {
    let item: StoredItem
    
    @State private var endpoint1: UnitPoint = .bottomLeading
    @State private var endpoint2: UnitPoint = .topTrailing
    
    
    var body: some View {
        GeometryReader { proxy in
            let proxyWidth = proxy.size.width
            HStack {
                if let photo = item.photo {
                    Image(data: photo)!
                        .resizable()
                        .frame(width: proxyWidth / 4, height: proxyWidth / 4)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Rectangle()
                        .clipShape(
                            .rect(
                                topLeadingRadius: 35,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 35
                            )
                        )
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
                    Text(item.name)
                        .font(.title)
                    HStack {
                        Button {
                            // delete an item
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
                        NavigationLink(value: item) {
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
}

#Preview {
    StoredItemDataSource.shared.appendItem(item: StoredItem(name: "Testing item", itemDescription: "This item is used for testing", location: nil))
    return QRItemView(item: StoredItemDataSource.shared.fetchItems().first!)
}
