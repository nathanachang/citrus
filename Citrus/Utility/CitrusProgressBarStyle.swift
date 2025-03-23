import SwiftUI

struct CitrusProgressBarStyle {
    var backgroundColor: Color = Constants.bgActionNeutralDefault
    var progressColor: Color = Color(hex: "#27aa00")
    var height: CGFloat = 8
    var cornerRadius: CGFloat? = nil
    var showAnimation: Bool = true
    var animationDuration: Double = 0.5
    
    func makeBody(progress: Double) -> some View {
        CitrusProgressBarImpl(
            progress: progress,
            style: self
        )
    }
}

private struct CitrusProgressBarImpl: View {
    var progress: Double
    var style: CitrusProgressBarStyle
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: style.cornerRadius ?? (style.height / 2))
                    .fill(style.backgroundColor)
                    .frame(height: style.height)
                
                // Progress indicator
                RoundedRectangle(cornerRadius: style.cornerRadius ?? (style.height / 2))
                    .fill(style.progressColor)
                    .frame(
                        width: max(
                            style.height,
                            geometry.size.width * CGFloat(style.showAnimation ? animatedProgress : progress)
                        ),
                        height: style.height
                    )
            }
        }
        .frame(height: style.height)
        .onAppear {
            if style.showAnimation {
                withAnimation(.easeOut(duration: style.animationDuration)) {
                    animatedProgress = progress
                }
            }
        }
        .onChange(of: progress) { newProgress in
            if style.showAnimation {
                withAnimation(.easeOut(duration: style.animationDuration)) {
                    animatedProgress = newProgress
                }
            }
        }
    }
}

// MARK: - Usage Example
struct CitrusProgressBar: View {
    var progress: Double // 0.0 to 1.0
    var style: CitrusProgressBarStyle = CitrusProgressBarStyle()
    
    init(progress: Double) {
        self.progress = min(max(progress, 0), 1) // Clamp between 0 and 1
    }
    
    var body: some View {
        style.makeBody(progress: progress)
    }
}

// MARK: - Style Modifiers
extension CitrusProgressBar {
    func progressColor(_ color: Color) -> CitrusProgressBar {
        var newStyle = style
        newStyle.progressColor = color
        return CitrusProgressBar(progress: progress).style(newStyle)
    }
    
    func backgroundColor(_ color: Color) -> CitrusProgressBar {
        var newStyle = style
        newStyle.backgroundColor = color
        return CitrusProgressBar(progress: progress).style(newStyle)
    }
    
    func height(_ height: CGFloat) -> CitrusProgressBar {
        var newStyle = style
        newStyle.height = height
        return CitrusProgressBar(progress: progress).style(newStyle)
    }
    
    func cornerRadius(_ radius: CGFloat) -> CitrusProgressBar {
        var newStyle = style
        newStyle.cornerRadius = radius
        return CitrusProgressBar(progress: progress).style(newStyle)
    }
    
    func animation(enabled: Bool, duration: Double = 0.5) -> CitrusProgressBar {
        var newStyle = style
        newStyle.showAnimation = enabled
        newStyle.animationDuration = duration
        return CitrusProgressBar(progress: progress).style(newStyle)
    }
    
    func style(_ style: CitrusProgressBarStyle) -> CitrusProgressBar {
        var progressBar = self
        progressBar.style = style
        return progressBar
    }
}
