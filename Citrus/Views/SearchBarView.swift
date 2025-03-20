//
//  SearchBarView.swift
//  Citrus
//
//  Created by Nathan Chang on 3/19/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchQuery: String
    @FocusState.Binding var isSearchFocused: Bool
    var onSearchQueryChanged: ((String) -> Void)?
    var showClearButton: Bool = false
    var onClearTapped: (() -> Void)?

    var body: some View {
        ZStack(alignment: .leading) {
            TextField("Search for a location", text: $searchQuery)
                .padding(.vertical, Constants.spacingTight)
                .padding(.leading, Constants.spacingDefault + 18) // Space for left icon
                .padding(.horizontal, Constants.spacingDefault)
                .background(Constants.bgActionNeutralDefault)
                .cornerRadius(999)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .textFieldStyle(PlainTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 999)
                        .inset(by: 1)
                        .stroke(isSearchFocused ? Constants.borderMuted : Color.clear, lineWidth: Constants.border50)
                        .animation(.easeInOut(duration: 0.25), value: isSearchFocused)
                )
                .focused($isSearchFocused)
                .onChange(of: searchQuery) { newValue in
                    onSearchQueryChanged?(newValue)
                }
                .onTapGesture {
                    isSearchFocused = true
                }

            // Left Icon
            Image(.citrusLogo)
                .padding(.leading, Constants.spacingDefault)

            // Right Icon
            HStack {
                Spacer()
                Button(action: {
                    onClearTapped?()
                }) {
                    Image(systemName: showClearButton ? "xmark.circle.fill" : "mic")
                        .padding(.trailing, Constants.spacingDefault)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: Constants.searchWidth)
    }
}
