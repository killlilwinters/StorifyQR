//
//  SQRWatermark.swift
//  StorifyQR
//
//  Created by Maks Winters on 20.05.2024.
//

import SwiftUI

struct ShareableImage: Transferable {
    let image: UIImage
    let filename: String
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            item.image.pngData()!
        }
        .suggestedFileName { item in
            item.filename
        }
    }
}

struct SQRWatermark: View {

    let item: StoredItem
    let padGradient = LinearGradient(colors: [.yellow, .blue], startPoint: .bottomLeading, endPoint: .topTrailing)
    let converter = ImageCoverter()
    
    var body: some View {
        VStack {
            Image(uiImage: converter.convertImage(ciImage: item.qrCode).resize())
            bar()
        }
    }
    
    func bar() -> some View {
        Rectangle()
            .frame(height: 100)
            .foregroundStyle(padGradient)
            .overlay {
                HStack {
                    Image(.logo)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .padding(10)
                        .padding(.leading, 5)
                    Text("StorifyQR")
                        .foregroundStyle(.black.opacity(0.8))
                        .font(.system(size: 50, weight: .bold))
                    Spacer()
                    Text(item.name.limit(limit: 10))
                        .foregroundStyle(.white)
                        .foregroundStyle(.black.opacity(0.8))
                        .font(.system(size: 50, weight: .medium))
                        .padding(.horizontal)
                }
            }
    }
    
}

#Preview(traits: .sizeThatFitsLayout) {
    StoredItemDataSource.shared.appendItem(item: StoredItem(name: "Testing item", itemDescription: "This item is used for testing", location: nil))
    return SQRWatermark(item: StoredItemDataSource.shared.fetchItems().first!)
}

