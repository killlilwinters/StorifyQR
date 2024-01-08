//
//  AddTagView.swift
//  StorifyQR
//
//  Created by Maks Winters on 08.01.2024.
//
// https://stackoverflow.com/questions/70528374/how-do-i-define-a-struct-property-to-accept-linear-or-angular-gradients-in-swift/70528437#70528437?newreg=404101891ecd4e6a9f8852d7d89ce698
//

import SwiftUI

struct AddTagView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: AddTagViewModel
    
    var body: some View {
        Background {
            VStack {
                VStack {
                    Text("Name:")
                        .font(.system(.headline))
                        .padding(.horizontal)
                    TextField("Enter a title", text: $viewModel.title)
                        .frame(height: 50)
                }
                .modifier(ContentPad())
                .padding(.horizontal)
                .frame(height: 100)
                HStack {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        StyledButtonComponent(title: "Cancel", foregroundStyle: .blue.gradient)
                    }
                    Button {
                        if let tag = viewModel.makeTag() {
                            viewModel.saveTo(tag)
                        }
                        dismiss()
                    } label: {
                        StyledButtonComponent(title: "Add", foregroundStyle: .orange.gradient)
                    }
                }
                .padding()
            }
        }
    }
    
    init(saveTo: @escaping (Tag) -> Void) {
        self.viewModel = AddTagViewModel(saveTo: saveTo)
    }
}

#Preview {
    AddTagView(saveTo: { _ in })
}
