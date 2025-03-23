//
//  QRScannerView.swift
//  StorifyQR
//
//  Created by Maks Winters on 28.05.2024.
//
// https://stackoverflow.com/a/65095862
//

import SwiftUI

struct QRScannerView: View {
    
    @State private var viewModel = QRScanneerViewModel()
    @State private var scannerID = UUID()
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                DataScannerViewRepresentable(
                    shouldCapturePhoto: .constant(false),
                    capturedPhoto: .constant(nil),
                    recognizedItems: $viewModel.recognizedItems,
                    recognizedDataType: .barcode(),
                    recognizesMultipleItems: false)
                .ignoresSafeArea()
                .id(scannerID)
                VStack {
                    Spacer()
                    Rectangle()
                        .scanningPad(proxy: proxy)
                        .overlay {
                            switch viewModel.itemToShow {
                            case .success(let item):
                                handleScanningSuccess(item: item)
                            case .failure(let error):
                                handleScanningError(error: error)
                            default:
                                ContentUnavailableView("Looking for QR Codes...", systemImage: "qrcode.viewfinder")
                            }
                        }
                }
            }
        }
        .onChange(of: viewModel.recognizedItems) {
            withOptionalAnimation() {
                viewModel.updateItemToShow()
            }
        }
        .onAppear {
            scannerID = UUID()
        }
    }
    
    func handleScanningSuccess(item: StoredItem) -> some View {
        QRItemView(item: item) { item in
            viewModel.deleteItem(item: item)
        }
        .transition(.scale)
    }
    
    func handleScanningError(error: any Error) -> some View {
        if error as! ScanErrors == ScanErrors.insufficientQRCode {
            ContentUnavailableView("Cannot recognize this QR Code...", systemImage: "info.circle")
        } else {
            ContentUnavailableView("Unknown error", systemImage: "exclamationmark.triangle", description: Text(error.localizedDescription))
        }
    }
    
}

#Preview {
    QRScannerView()
}
