//
//  SegmentedControlsScreen.swift
//  CitrusUI
//
//  Created by Paul Minyoo Kim on 3/9/25.
//

import SwiftUI

struct SegmentedControlExampleView: View {
    // MARK: - State
    @State private var viewMode = 0
    @State private var timeRange = 0
    @State private var filterOption = 0
    @State private var sortOption = "newest"
    
    // MARK: - Constants
    private let viewModeOptions = ["Map", "List"]
    private let timeRangeOptions = ["Day", "Week", "Month"]
    private let filterOptions = ["All", "Favorites", "Recent", "Archived"]
    private let sortOptions = ["newest", "oldest", "alphabetical", "rating"]
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text("🍊 Citrus Segmented Controls")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Two-segment example
                VStack(alignment: .leading, spacing: 10) {
                    Text("View Mode")
                        .font(.headline)
                    
                    CitrusSegmentedControl(
                        selection: $viewMode,
                        options: [0, 1],
                        labels: [0: "Map", 1: "List"]
                    )
                    .frame(height: 44)
                    
                    Text("Selected: \(viewModeOptions[viewMode])")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Three-segment example
                VStack(alignment: .leading, spacing: 10) {
                    Text("Time Range")
                        .font(.headline)
                    
                    CitrusSegmentedControl(
                        selection: $timeRange,
                        options: [0, 1, 2],
                        labels: [0: "Day", 1: "Week", 2: "Month"]
                    )
                    .frame(height: 44)
                    
                    Text("Selected: \(timeRangeOptions[timeRange])")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Four-segment example
                VStack(alignment: .leading, spacing: 10) {
                    Text("Filter")
                        .font(.headline)
                    
                    CitrusSegmentedControl(
                        selection: $filterOption,
                        options: [0, 1, 2, 3],
                        labels: [0: "All", 1: "Favorites", 2: "Recent", 3: "Archived"]
                    )
                    .frame(height: 44)
                    
                    Text("Selected: \(filterOptions[filterOption])")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // String-based example
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sort By")
                        .font(.headline)
                    
                    CitrusSegmentedControl(
                        selection: $sortOption,
                        options: sortOptions
                    )
                    .frame(height: 44)
                    
                    Text("Selected: \(sortOption)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Custom styling example
                VStack(alignment: .leading, spacing: 10) {
                    Text("Custom Styling")
                        .font(.headline)
                    
                    CitrusSegmentedControl(
                        selection: $timeRange,
                        options: [0, 1, 2],
                        labels: [0: "Day", 1: "Week", 2: "Month"]
                    )
                    .accentColor(.blue)
                    .backgroundColor(Color.blue.opacity(0.1))
                    .frame(height: 44)
                }
            }
            .padding()
        }
    }
}

// MARK: - Modifier Extensions
extension CitrusSegmentedControl {
    func accentColor(_ color: Color) -> CitrusSegmentedControl {
        var control = self
        control.accentColor = color
        return control
    }
    
    func backgroundColor(_ color: Color) -> CitrusSegmentedControl {
        var control = self
        control.backgroundColor = color
        return control
    }
    
    func textColor(_ color: Color) -> CitrusSegmentedControl {
        var control = self
        control.textColor = color
        return control
    }
    
    func selectedTextColor(_ color: Color) -> CitrusSegmentedControl {
        var control = self
        control.selectedTextColor = color
        return control
    }
    
    func height(_ height: CGFloat) -> CitrusSegmentedControl {
        var control = self
        control.height = height
        return control
    }
    
    func cornerRadius(_ radius: CGFloat) -> CitrusSegmentedControl {
        var control = self
        control.cornerRadius = radius
        return control
    }
}

struct SegmentedControlExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControlExampleView()
    }
}
