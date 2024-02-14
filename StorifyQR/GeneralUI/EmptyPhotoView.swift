//
//  EmptyPhotoView.swift
//  StorifyQR
//
//  Created by Maks Winters on 14.02.2024.
//

import SwiftUI

struct EmptyPhotoView: View {
    var body: some View {
        Rectangle()
            .frame(height: 250)
            .foregroundStyle(.link)
            .overlay (
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 100))
            )
    }
}
