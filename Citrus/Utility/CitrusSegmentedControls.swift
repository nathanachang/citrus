//
//  SegmentedControls.swift
//  CitrusUI
//
//  Created by Paul Minyoo Kim on 3/9/25.
//

import SwiftUI

struct CitrusSegmentedControl<T: Hashable>: View {
    // MARK: - Properties
    @Binding var selection: T
    let options: [T]
    let labels: [T: String]
    
    // Optional customization
    var backgroundColor: Color = Color(UIColor.systemGray6)
    var accentColor: Color = Color(hex: "#9747ff")
    var textColor: Color = .black
    var selectedTextColor: Color = .white
    var height: CGFloat = 44
    var cornerRadius: CGFloat = 22
    
    // MARK: - Initializers
    init(selection: Binding<T>, options: [T], labels: [T: String]) {
        self._selection = selection
        self.options = options
        self.labels = labels
    }
    
    init(selection: Binding<T>, options: [T]) where T: CustomStringConvertible {
        self._selection = selection
        self.options = options
        self.labels = Dictionary(uniqueKeysWithValues: options.map { ($0, $0.description) })
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                
                // Selected segment indicator
                if let index = options.firstIndex(of: selection) {
                    RoundedRectangle(cornerRadius: cornerRadius - 4)
                        .fill(accentColor)
                        .frame(width: segmentWidth(in: geometry))
                        .offset(x: segmentOffset(for: index, in: geometry))
                        .animation(.easeInOut(duration: 0.2), value: selection)
                }
                
                // Segments
                HStack(spacing: 0) {
                    ForEach(options.indices, id: \.self) { index in
                        Button(action: {
                            selection = options[index]
                        }) {
                            Text(labels[options[index]] ?? "")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(options[index] == selection ? selectedTextColor : textColor)
                                .frame(width: segmentWidth(in: geometry), height: height)
                        }
                    }
                }
                
                // Dividers
                if options.count > 2 {
                    HStack(spacing: 0) {
                        ForEach(1..<options.count, id: \.self) { index in
                            Spacer()
                            if options[index-1] != selection && options[index] != selection {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 1, height: height - 16)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .frame(height: height)
        }
        .frame(height: height)
    }
    
    // MARK: - Helper Methods
    private func segmentWidth(in geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width / CGFloat(options.count)
    }
    
    private func segmentOffset(for index: Int, in geometry: GeometryProxy) -> CGFloat {
        return CGFloat(index) * segmentWidth(in: geometry)
    }
}

// MARK: - Preview
struct CitrusSegmentedControl_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selection2 = 0
        @State private var selection3 = 0
        @State private var selection4 = 0
        @State private var selection5 = 0
        
        var body: some View {
            ScrollView {
                VStack(spacing: 30) {
                    Text("Segmented Controls")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Group {
                        Text("2 Segments")
                            .font(.headline)
                        
                        CitrusSegmentedControl(
                            selection: $selection2,
                            options: [0, 1],
                            labels: [0: "Label", 1: "Label"]
                        )
                        .frame(height: 44)
                    }
                    
                    Group {
                        Text("3 Segments")
                            .font(.headline)
                        
                        CitrusSegmentedControl(
                            selection: $selection3,
                            options: [0, 1, 2],
                            labels: [0: "Label", 1: "Label", 2: "Label"]
                        )
                        .frame(height: 44)
                    }
                    
                    Group {
                        Text("4 Segments")
                            .font(.headline)
                        
                        CitrusSegmentedControl(
                            selection: $selection4,
                            options: [0, 1, 2, 3],
                            labels: [0: "Label", 1: "Label", 2: "Label", 3: "Label"]
                        )
                        .frame(height: 44)
                    }
                    
                    Group {
                        Text("5 Segments")
                            .font(.headline)
                        
                        CitrusSegmentedControl(
                            selection: $selection5,
                            options: [0, 1, 2, 3, 4],
                            labels: [0: "Label", 1: "Label", 2: "Label", 3: "Label", 4: "Label"]
                        )
                        .frame(height: 44)
                    }
                }
                .padding()
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
