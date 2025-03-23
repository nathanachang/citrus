import SwiftUI

struct CitrusSegmentedControlStyle {
    var backgroundColor: Color = Constants.bgActionNeutralDefault
    var accentColor: Color = Constants.bgCitrusPurpleDefault
    var textColor: Color = Constants.textNeutral
    var selectedTextColor: Color = Constants.textInverse
    var height: CGFloat = 44
    var cornerRadius: CGFloat = Constants.spacingRadiusTight
    
    func makeBody<T: Hashable>(selection: Binding<T>, options: [T], labels: [T: String]) -> some View {
        CitrusSegmentedControlImpl(
            selection: selection,
            options: options,
            labels: labels,
            style: self
        )
    }
}

private struct CitrusSegmentedControlImpl<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let labels: [T: String]
    let style: CitrusSegmentedControlStyle
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.backgroundColor)
                
                // Selected segment indicator
                if let index = options.firstIndex(of: selection) {
                    RoundedRectangle(cornerRadius: style.cornerRadius - 4)
                        .fill(style.accentColor)
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
                                .foregroundColor(options[index] == selection ? style.selectedTextColor : style.textColor)
                                .frame(width: segmentWidth(in: geometry), height: style.height)
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
                                    .fill(Constants.borderNeutral)
                                    .frame(width: Constants.borderDefault, height: style.height - 16)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .frame(height: style.height)
        }
        .frame(height: style.height)
    }
    
    private func segmentWidth(in geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width / CGFloat(options.count)
    }
    
    private func segmentOffset(for index: Int, in geometry: GeometryProxy) -> CGFloat {
        return CGFloat(index) * segmentWidth(in: geometry)
    }
}

// MARK: - Usage Example
struct CitrusSegmentedControl<T: Hashable>: View {
    @Binding var selection: T
    let options: [T]
    let labels: [T: String]
    var style: CitrusSegmentedControlStyle = CitrusSegmentedControlStyle()
    
    var body: some View {
        style.makeBody(selection: $selection, options: options, labels: labels)
    }
}
