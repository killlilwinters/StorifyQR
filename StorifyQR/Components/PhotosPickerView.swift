//
//  PhotosPickerView.swift
//  StorifyQR
//
//  Created by Maks Winters on 09.04.2025.
//

import SwiftUI
import PhotosUI

struct PhotosPickerView: View {
    
    @Binding var image: Image?
    @Binding var pickerItem: PhotosPickerItem?
    let loadImage: () -> Void
    
    var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .makeiPadScreenCompatible()
            } else {
                EmptyPhotoView()
                    .makeiPadScreenCompatible()
            }
            PhotosPicker(selection: $pickerItem, matching: .images) {
                SelectPhotoButtonView()
            }
                .buttonStyle(.plain)
                .clipShape(.capsule)
                .padding(.top)
                .onChange(of: pickerItem, loadImage)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PhotosPickerView(image: .constant(nil), pickerItem: .constant(nil), loadImage: { })
}
