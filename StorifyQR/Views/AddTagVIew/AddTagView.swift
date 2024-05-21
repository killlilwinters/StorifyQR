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
    @State var classifierInstance: AbstractClassifier
    
    var body: some View {
    NavigationStack {
        Background {
                ZStack(alignment: .bottom) {
                    ScrollView(.vertical) {
                        VStack {
                            suggestionView
                            Divider()
                            chipsView
                        }
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
                            .onChange(of: viewModel.tagText, viewModel.limitTextField)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .strokeBorder()
                                    .foregroundColor(.primary)
                            )
                            Button {
                                withOptionalAnimation {
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
                                .foregroundStyle(.themeRelative)
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
                                            .fill(row.tagColor.gradient)
                                        Button {
                                            viewModel.requestDelete(tag: row)
                                        } label:{
                                            Image(systemName: "trash")
                                                .frame(width: 15, height: 15)
                                                .padding(.trailing, 10)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                )
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
        .alert("Are you sure?", isPresented: $viewModel.isShowingDeleteAlert) {
            Button("Confirm", role: .destructive) {
                viewModel.deleteTag(tag: viewModel.tagToDelete!)
            }
        } message: {
            Text("This action will delete: \(viewModel.tagToDelete?.title ?? "Unknown")")
        }
    }
    
    var suggestionView: some View {
        VStack {
            HStack {
                Image(systemName: "wand.and.stars")
                Text("Suggestions")
            }
            HStack {
                lazy var results = classifierInstance.otherResults
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(results, id: \.self) { str in
                            MLTagView(title: str)
                                .onTapGesture {
                                    viewModel.sendMLTagOut(title: str)
                                    dismiss()
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .scrollIndicators(.hidden)
                .overlay (
                    results.isEmpty ? Text("Choose a photo or use another one to start").foregroundStyle(.secondary) : nil
                )
            }
        }
    }
    
    init(
        classifierInstance: AbstractClassifier,
        saveTo: @escaping (Tag) -> Void
    ) {
        self.classifierInstance = classifierInstance
        self.viewModel = AddTagViewModel(saveTo: saveTo)
    }
}

#Preview {
    AddTagView(
        classifierInstance: AbstractClassifier(),
        saveTo: { _ in }
    )
}
