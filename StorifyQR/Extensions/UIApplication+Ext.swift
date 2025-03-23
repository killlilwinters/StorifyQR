//
//  UIApplication+Ext.swift
//  StorifyQR
//
//  Created by Maks Winters on 23.03.2025.
//
// https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
