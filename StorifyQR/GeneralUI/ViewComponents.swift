//
//  ViewComponents.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//
// https://stackoverflow.com/questions/70528374/how-do-i-define-a-struct-property-to-accept-linear-or-angular-gradients-in-swift
//

import Foundation
import SwiftUI

struct ContentPad: ViewModifier {
    var cornerRaduius: Double = 25
    var enablePadding: Bool = true
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRaduius)
                .foregroundStyle(Color(.contentPad))
            content
                .padding(enablePadding ? 15 : 0)
        }
        .makeiPadScreenCompatible()
    }
}

struct SelectPhotoButtonView: View {
    var body: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
            Text("Select a photo")
        }
        .foregroundStyle(.reversed)
        .font(.system(size: 15))
        .padding(10)
        .background(.themeRelative)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
}

struct DeletableTagView: View {
    
    let tag: Tag
    var pingRemove: () -> Void
    
    var body: some View {
        if tag.isMLSuggested {
            viewItself
                .background(LinearGradient(colors: [.tagRed, .tagBlue], startPoint: .bottomLeading, endPoint: .topTrailing))
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
        } else {
            viewItself
                .background(tag.tagColor.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
        }
    }
    
    var viewItself: some View {
        HStack {
            Text(tag.title)
                .foregroundStyle(.themeRelative)
            Button {
                pingRemove()
                
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 15, height: 15)
                    .foregroundColor(.secondary)
            }
        }
        .padding(10)
        .foregroundStyle(.white)
    }
}

struct TagView: View {
    
    var tag: Tag
    
    var body: some View {
        if !tag.isMLSuggested {
            Text(tag.title)
                .padding(10)
                .foregroundStyle(.themeRelative)
                .background(tag.tagColor.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
        } else {
            MLTagView(title: tag.title)
        }
    }
}

struct MLTagView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .padding(10)
            .foregroundStyle(.themeRelative)
            .background(LinearGradient(colors: [.tagRed, .tagBlue], startPoint: .bottomLeading, endPoint: .topTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
}

struct ActionButton: View {
    
    let sfImage: String?
    let buttonText: String
    let color: Color
    
    var body: some View {
        HStack {
            if sfImage != nil {
                Image(systemName: sfImage!)
                    .foregroundStyle(color)
                    .frame(width: 20, height: 20)
            }
            Text(buttonText)
                .foregroundStyle(.themeRelative)
        }
    }
}

struct StyledButtonComponent<Style: ShapeStyle>: View {
    
    let title: String
    var foregroundStyle: Style
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(foregroundStyle)
            .overlay (
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.black)
            )
            .frame(height: 50)
            .makeiPadScreenCompatible()
    }
}

struct LocationNameBar: View {
    
    let locationName: String
    
    var body: some View {
        Text(locationName)
            .padding(10)
            .frame(maxWidth: .infinity)
            .background (
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(.pink.opacity(0.7))
            )
    }
}
