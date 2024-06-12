//
//  OnboardingView.swift
//  StorifyQR
//
//  Created by Maks Winters on 11.06.2024.
//
// https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates
//
// https://www.hackingwithswift.com/books/ios-swiftui/alignment-and-alignment-guides
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var dateColors: [Color] {
        let currentDate = Date.now
        let components = Calendar.current.dateComponents([.month], from: currentDate)
        if components.month == 6 {
            return [.red, .orange, .yellow, .green, .blue, .pink]
        } else {
            return [.blue, .yellow, .blue, .yellow]
        }
    }
    
    var body: some View {
        Background {
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    Text("Welcome to")
                    AuroraEffectView(colors: dateColors, backgroundTint: nil)
                        .frame(width: 230, height: 45)
                        .mask {
                            Text("StorifyQR")
                        }
                }
                .font(.system(size: 40, weight: .bold, design: .default))
                bulletPoints
                    .padding(40)
                Spacer()
                Spacer()
                Button {
                    dismiss()
                } label: {
                    StyledButtonComponent(foregroundStyle: Color.tagBlue, title: Text("Continue"))
                        .containerRelativeFrame(.horizontal) { width, axis in
                            width * 0.7
                        }
                }
                .padding(30)
            }
        }
    }
    
    var bulletPoints: some View {
        VStack(alignment: .listRowSeparatorLeading, spacing: 30) {
            HStack {
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 30))
                    .foregroundStyle(.blue)
                VStack(alignment: .leading) {
                    Text("Create items")
                        .bold()
                    Text("Create, view, modify any item in your storage!")
                        .foregroundStyle(.secondary)
                }
            }
            HStack {
                Image(systemName: "printer")
                    .font(.system(size: 30))
                    .foregroundStyle(.blue)
                VStack(alignment: .leading) {
                    Text("Print QR Codes")
                        .bold()
                    Text("Print the generated QR codes to quickly locate any item!")
                        .foregroundStyle(.secondary)
                }
            }
            HStack {
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 30))
                    .foregroundStyle(.blue)
                VStack(alignment: .leading) {
                    Text("Scan to peek inside")
                        .bold()
                    Text("Use in-app's scanner to identify the contents of your storage unit!")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
