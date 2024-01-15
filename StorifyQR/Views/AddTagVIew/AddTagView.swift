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
    NavigationStack {
        Background {
                ZStack(alignment: .bottom) {
                    ScrollView(.vertical) {
                        chipsView
                    }
                    VStack {
                        if viewModel.isShowingSelectior {
                            CustomColorPickerView(selectedColor: $viewModel.selectedColor)
                        }
                        HStack {
                            TextField("Enter tag", text: $viewModel.tagText, onCommit: {
                                viewModel.addTag()
                            })
                            .autocorrectionDisabled()
                            .onChange(of: viewModel.tagText) {
                                viewModel.limitTextField()
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .strokeBorder()
                                    .foregroundColor(.primary)
                            )
                            Button {
                                withAnimation {
                                    viewModel.isShowingSelectior.toggle()
                                }
                            } label: {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .fill(.primary)
                                    .frame(height: 55)
                                    .overlay(
                                        Circle()
                                            .fill(viewModel.selectedColor)
                                            .frame(width: 20)
                                    )
                            }
                            .buttonStyle(.plain)
                            Button {
                                viewModel.addTag()
                            } label: {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .fill(.primary)
                                    .frame(height: 55)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .foregroundStyle(.primary)
                                            .font(.system(size: 20))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                }
                .navigationTitle("Tag picker")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    var chipsView: some View {
        VStack{
            VStack(alignment: .leading, spacing: 4) {
                ForEach(viewModel.rows, id: \.self) { rows in
                    HStack(spacing: 6) {
                        ForEach(rows){ row in
                            Text(row.title)
                                .fixedSize()
                                .foregroundStyle(.white)
                                .font(.system(size: 16))
                                .padding(.leading, 14)
                                .padding(.trailing, 30)
                                .padding(.vertical, 10)
                                .onTapGesture {
                                    viewModel.saveTo(row)
                                    dismiss()
                                }
                                .background(
                                    ZStack(alignment: .trailing){
                                        Capsule()
                                            .fill(row.colorComponent.getColor.gradient)
                                        Button{
                                            viewModel.removeTag(by: row.title)
                                        } label:{
                                            Image(systemName: "xmark")
                                                .frame(width: 15, height: 15)
                                                .padding(.trailing, 10)
                                                .foregroundColor(.white)
                                        }
                                    }
                                )
                                .shadow(radius: 3)
                        }
                        Spacer()
                    }
                    .frame(height: 28)
                    .padding(.bottom, 15)
                }
            }
            .padding(24)
            
            Spacer()
        }
    }
    
    init(saveTo: @escaping (Tag) -> Void) {
        self.viewModel = AddTagViewModel(saveTo: saveTo)
    }
}

#Preview {
    AddTagView(saveTo: { _ in })
}
