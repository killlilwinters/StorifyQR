//
//  InlineSearchBar.swift
//  StorifyQR
//
//  Created by Maks Winters on 07.04.2025.
//

import SwiftUI

struct InlineSearchBar: View {
    
    @Binding var isSearching: Bool
    @Binding var searchText: String
    
    var body: some View {
        Capsule()
            .tint(.primary)
            .overlay (
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.reversed)
                        .onTapGesture {
                            withOptionalAnimation {
                                isSearching.toggle()
                            }
                        }
                    if isSearching {
                        TextField("", text: $searchText)
                            .foregroundStyle(.reversed)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Search...").foregroundColor(.reversed)
                            }
                    }
                }
                    .padding(.horizontal)
            )
            .frame(width: isSearching ? 200 : 45, height: 45)
    }
    
}

#Preview {
    InlineSearchBar(
        isSearching: .constant(true),
        searchText: .constant("Hello, World!")
    )
}
