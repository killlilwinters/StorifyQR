//
//  QRScannerBackend.swift
//  StorifyQR
//
//  Created by Maks Winters on 29.05.2024.
//
// https://medium.com/ciandt-techblog/live-data-scanning-on-ios-a-quick-look-at-apples-visionkit-framework-682ea50fa04b
// https://apps.apple.com/ua/app/companion-for-swiftui/id6475761721
// https://developer.apple.com/documentation/avfoundation/capture_setup/requesting_authorization_to_capture_and_save_media
//

import SwiftUI
import UIKit
import Vision
import VisionKit

struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

struct DataScannerViewRepresentable: UIViewControllerRepresentable {
    
    @Binding var shouldCapturePhoto: Bool
    @Binding var capturedPhoto: IdentifiableImage?
    @Binding var recognizedItems: [String]
    let recognizedDataType: DataScannerViewController.RecognizedDataType
    let recognizesMultipleItems: Bool
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [recognizedDataType],
            qualityLevel: .balanced,
            recognizesMultipleItems: recognizesMultipleItems,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
        if shouldCapturePhoto {
            capturePhoto(dataScannerVC: uiViewController)
        }
    }
    
    private func capturePhoto(dataScannerVC: DataScannerViewController) {
        Task { @MainActor in
            do {
                let photo = try await dataScannerVC.capturePhoto()
                self.capturedPhoto = .init(image: photo)
            } catch {
                print(error.localizedDescription)
            }
            self.shouldCapturePhoto = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItems: $recognizedItems)
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
}

class Coordinator: NSObject, DataScannerViewControllerDelegate {
    
    @Binding var recognizedItems: [String]

    init(recognizedItems: Binding<[String]>) {
        self._recognizedItems = recognizedItems
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        print("didTapOn")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        let itemsToAdd = addedItems.compactMap { recognizedItem in
            switch recognizedItem {
            case .barcode(let barcode):
                barcode.payloadStringValue
            case .text(let text):
                text.transcript
            default:
                "Unknown case"
            }
        }
        recognizedItems.append(contentsOf: itemsToAdd)
        print("didAddItems")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        let removedItemsStrings = removedItems.compactMap { recognizedItem in
            switch recognizedItem {
            case .barcode(let barcode):
                barcode.payloadStringValue
            case .text(let text):
                text.transcript
            default:
                "Unknown case"
            }
        }
//        self.recognizedItems = recognizedItems.filter { item in
//            !removedItemsStrings.contains(where: { $0 == item })
//        }
        print("didRemovedItems")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        print("became unavailable with error \(error.localizedDescription)")
    }
}
