//
//  DateConverter.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//

import Foundation

struct DateConverter {
    static let formatter = DateFormatter()
    let date: Date
    
    func format() -> String {
        DateConverter.formatter.dateStyle = .medium
        let finalDate = DateConverter.formatter.string(from: date)
        return finalDate
    }
}
