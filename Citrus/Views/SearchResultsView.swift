//
//  SearchResultsView.swift
//  Citrus
//
//  Created by Nathan Chang on 3/20/25.
//

import SwiftUI
import MapKit

struct SearchResultsView: View {
    var searchResults: [MKMapItem]
    var onResultSelected: (MKMapItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(searchResults, id: \.self) { item in
                    Button(action: {
                        onResultSelected(item)
                    }) {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 16))
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Unknown Place")
                                    .foregroundColor(Constants.textNeutral)
                                    .font(.system(size: 16, weight: .medium))
                                if let address = LocationSearchService.getAddressFromItem(item) {
                                    Text(address)
                                        .foregroundColor(Constants.textNeutral)
                                        .font(.system(size: 14))
                                        .lineLimit(1)
                                }
                            }
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                    }
                    .background(Constants.bgNeutral)
                    
                    Divider()
                        .padding(.horizontal, 16)
                }
            }
        }
        .frame(width: Constants.searchWidth, height: min(CGFloat(searchResults.count * 60), 300))
        .background(Constants.bgNeutral)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        .zIndex(1)
    }
}
