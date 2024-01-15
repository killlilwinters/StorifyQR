//
//  Tips.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//

import Foundation
import TipKit

struct QRCodeShareTip: Tip {
    var title: Text {
        Text("Share or save QR code!")
    }
    var message: Text? {
        Text("Tap on QR code to bring up sharing menu for generated QR code.")
    }
    var image: Image? {
        Image(systemName: "hand.tap")
    }
}
