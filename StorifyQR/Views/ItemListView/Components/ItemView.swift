//
//  ItemView.swift
//  StorifyQR
//
//  Created by Maks Winters on 07.04.2025.
//

import SwiftUI

struct ItemView: View {
    
    let image: Image?
    let name: String
    let itemDescription: String
    
    var body: some View {
        
        HStack {
            if image != nil {
                image!
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 25, bottomLeading: 25, bottomTrailing: 0, topTrailing: 0)))
            } else {
                HStack(spacing: 0) {
                    Image(systemName: "shippingbox")
                        .font(.system(size: 50))
                        .frame(width: 100, height: 100)
                    Rectangle()
                        .frame(width: 1, height: 100)
                }
            }
            VStack(alignment: .leading) {
                Text(name)
                    .bold()
                Text(itemDescription.limit(limit: 20))
            }
            .padding(.horizontal)
            Spacer()
        }
        .modifier(ContentPad(enablePadding: false))
        .padding(.horizontal)
        
    }
}

#Preview {
    ItemView(image: nil, name: "SomeItem", itemDescription: "Some description.")
}
