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
                        .clipShape(
                            .rect(
                                topLeadingRadius:35,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 35
                            )
                        )
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
        .onAppear {
            scannerID = UUID()
        }
    }
}

#Preview {
    QRScannerView()
}
