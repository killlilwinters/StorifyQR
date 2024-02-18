//
//  SearchBar.swift
//  StorifyQR
//
//  Created by Maks Winters on 18.02.2024.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    var notEmpty: Bool {
        !searchText.isEmpty
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search...", text: $searchText)
            Spacer()
                Button {
                    searchText.removeAll()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 20))
                }
                .opacity(notEmpty ? 1 : 0)
                .buttonStyle(.plain)
                .animation(.easeInOut, value: notEmpty)
        }
            .modifier(ContentPad(cornerRaduius: 30, enablePadding: true))
            .frame(height: 30)
    }
}

#Preview {
    @State var searchText = ""
    return SearchBar(searchText: $searchText)
}
