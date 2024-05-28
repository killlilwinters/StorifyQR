//
//  QRScannerView.swift
//  StorifyQR
//
//  Created by Maks Winters on 28.05.2024.
//

import SwiftUI

struct QRScannerView: View {
    @State var recognizedItems: [String] = []
    
    @State var itemToShow: String = ""

    var body: some View {
        VStack {
            DataScannerViewRepresentable(
                shouldCapturePhoto: .constant(false),
                capturedPhoto: .constant(nil),
                recognizedItems: $recognizedItems,
                recognizedDataType: .barcode(),
                recognizesMultipleItems: false)
        }
        Text(itemToShow)
            .onChange(of: recognizedItems) {
                itemToShow = recognizedItems.last ?? ""
            }
    }
}

#Preview {
    QRScannerView()
}
