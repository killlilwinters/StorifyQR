//
//  QRScannerView.swift
//  StorifyQR
//
//  Created by Maks Winters on 28.05.2024.
//

import SwiftUI

struct QRScannerView: View {
    
    @State private var viewModel = QRScanneerViewModel()
    
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
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 40)
                        .foregroundStyle(Color.contentPad)
                        .ignoresSafeArea()
                        .frame(height: proxy.size.height / 4)
                        .overlay {
                            switch viewModel.itemToShow {
                            case .success(let item):
                                QRItemView(item: item)
                                    .transition(.scale)
                            case .failure(let failure):
                                failure as! ScanErrors == ScanErrors.insufficientQRCode
                                ?
                                ContentUnavailableView("Cannot recognize this QR Code...", systemImage: "info.circle")
                                :
                                ContentUnavailableView("Unknown error", systemImage: "exclamationmark.triangle", description: Text(failure.localizedDescription))
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
    }
}

#Preview {
    QRScannerView()
}
