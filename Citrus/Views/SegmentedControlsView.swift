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
                        options: sortOptions,
                        labels: Dictionary(uniqueKeysWithValues: sortOptions.map { ($0, $0.capitalized) })
                    )
                    
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
                        labels: [0: "Day", 1: "Week", 2: "Month"],
                        style: CitrusSegmentedControlStyle(
                            backgroundColor: Constants.bgCitrusPink.opacity(0.2),
                            accentColor: Constants.bgCitrusPurpleLight,
                            textColor: Constants.textNeutral,
                            selectedTextColor: Constants.textInverse,
                            height: 40,
                            cornerRadius: Constants.spacingRadiusDefault
                        )
                    )
                }
                
                // Buttons to control selection
                Group {
                    Text("Control with Buttons")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        ForEach(0..<3) { index in
                            Button(action: {
                                timeRange = index
                            }) {
                                Text(timeRangeOptions[index])
                            }
                            .buttonStyle(
                                CitrusButtonStyle(
                                    size: .small,
                                    fill: timeRange == index ? .fill : .outline
                                )
                            )
                        }
                    }
                    
                    CitrusSegmentedControl(
                        selection: $timeRange,
                        options: [0, 1, 2],
                        labels: [0: "Day", 1: "Week", 2: "Month"]
                    )
                }
            }
            .padding()
        }
    }
}

struct SegmentedControlExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControlExampleView()
    }
}
