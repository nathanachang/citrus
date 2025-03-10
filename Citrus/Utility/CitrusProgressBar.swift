//
//  CitrusProgressBar.swift
//  CitrusUI
//
//  Created by Paul Minyoo Kim on 3/9/25.
//

import SwiftUI

struct CitrusProgressBar: View {
    // MARK: - Properties
    var progress: Double // 0.0 to 1.0
    var height: CGFloat = 8
    var backgroundColor: Color = Color(UIColor.systemGray5)
    var progressColor: Color = Color(hex: "#27aa00") // Green color from Figma
    var showAnimation: Bool = true
    var animationDuration: Double = 0.5
    
    // MARK: - Private State
    @State private var animatedProgress: Double = 0
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(backgroundColor)
                    .frame(height: height)
                
                // Progress indicator
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(progressColor)
                    .frame(width: max(height, geometry.size.width * CGFloat(showAnimation ? animatedProgress : progress)), height: height)
            }
        }
        .frame(height: height)
        .onAppear {
            if showAnimation {
                withAnimation(.easeOut(duration: animationDuration)) {
                    animatedProgress = progress
                }
            }
        }
        .onChange(of: progress) { newProgress in
            if showAnimation {
                withAnimation(.easeOut(duration: animationDuration)) {
                    animatedProgress = newProgress
                }
            }
        }
    }
    
    // MARK: - Initializers
    init(progress: Double, height: CGFloat = 8) {
        self.progress = min(max(progress, 0), 1) // Clamp between 0 and 1
        self.height = height
    }
    
    // MARK: - Modifier Methods
    func progressColor(_ color: Color) -> CitrusProgressBar {
        var progressBar = self
        progressBar.progressColor = color
        return progressBar
    }
    
    func backgroundColor(_ color: Color) -> CitrusProgressBar {
        var progressBar = self
        progressBar.backgroundColor = color
        return progressBar
    }
    
    func height(_ height: CGFloat) -> CitrusProgressBar {
        var progressBar = self
        progressBar.height = height
        return progressBar
    }
    
    func animation(enabled: Bool, duration: Double = 0.5) -> CitrusProgressBar {
        var progressBar = self
        progressBar.showAnimation = enabled
        progressBar.animationDuration = duration
        return progressBar
    }
}

// MARK: - Preview
struct CitrusProgressBar_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var progress = 0.0
        
        var body: some View {
            VStack(spacing: 30) {
                Text("Progress Bars")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    ForEach([0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 1.0], id: \.self) { value in
                        CitrusProgressBar(progress: value)
                    }
                }
                
                Button("Animate Progress") {
                    progress = 0
                    withAnimation {
                        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                            progress += 0.01
                            if progress >= 1.0 {
                                timer.invalidate()
                            }
                        }
                    }
                }
                
                CitrusProgressBar(progress: progress)
                    .height(12)
                
                Text("Custom Styling")
                    .font(.headline)
                
                CitrusProgressBar(progress: 0.7)
                    .progressColor(.blue)
                    .backgroundColor(Color.blue.opacity(0.2))
                    .height(16)
                
                CitrusProgressBar(progress: 0.4)
                    .progressColor(.orange)
                    .backgroundColor(Color.orange.opacity(0.2))
                    .height(10)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
