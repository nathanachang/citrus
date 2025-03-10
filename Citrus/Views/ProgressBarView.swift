//
//  ProgressBarScreen.swift
//  CitrusUI
//
//  Created by Paul Minyoo Kim on 3/9/25.
//

import SwiftUI

struct ProgressBarExampleView: View {
    // MARK: - State
    @State private var downloadProgress = 0.0
    @State private var uploadProgress = 0.0
    @State private var taskProgress = 0.0
    @State private var isDownloading = false
    @State private var isUploading = false
    @State private var isTaskRunning = false
    
    // MARK: - Timer
    @State private var downloadTimer: Timer?
    @State private var uploadTimer: Timer?
    @State private var taskTimer: Timer?
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text("🍊 Citrus Progress Bars")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Basic progress bars
                Group {
                    Text("Basic Progress Bars")
                        .font(.headline)
                    
                    VStack(spacing: 20) {
                        progressSection(
                            title: "Download Progress",
                            progress: downloadProgress,
                            isRunning: isDownloading,
                            action: toggleDownload,
                            actionTitle: isDownloading ? "Pause" : "Start Download"
                        )
                        
                        progressSection(
                            title: "Upload Progress",
                            progress: uploadProgress,
                            isRunning: isUploading,
                            action: toggleUpload,
                            actionTitle: isUploading ? "Pause" : "Start Upload"
                        )
                        
                        progressSection(
                            title: "Task Completion",
                            progress: taskProgress,
                            isRunning: isTaskRunning,
                            action: toggleTask,
                            actionTitle: isTaskRunning ? "Stop" : "Start Task"
                        )
                    }
                }
                
                // Styled progress bars
                Group {
                    Text("Custom Styled Progress Bars")
                        .font(.headline)
                    
                    VStack(spacing: 16) {
                        Text("Different Heights")
                            .font(.subheadline)
                        
                        CitrusProgressBar(progress: 0.3)
                            .height(4)
                        
                        CitrusProgressBar(progress: 0.5)
                            .height(8)
                        
                        CitrusProgressBar(progress: 0.7)
                            .height(12)
                        
                        CitrusProgressBar(progress: 0.9)
                            .height(16)
                    }
                    
                    VStack(spacing: 16) {
                        Text("Different Colors")
                            .font(.subheadline)
                        
                        CitrusProgressBar(progress: 0.6)
                            .progressColor(.blue)
                            .backgroundColor(Color.blue.opacity(0.2))
                        
                        CitrusProgressBar(progress: 0.6)
                            .progressColor(.orange)
                            .backgroundColor(Color.orange.opacity(0.2))
                        
                        CitrusProgressBar(progress: 0.6)
                            .progressColor(.purple)
                            .backgroundColor(Color.purple.opacity(0.2))
                        
                        CitrusProgressBar(progress: 0.6)
                            .progressColor(.red)
                            .backgroundColor(Color.red.opacity(0.2))
                    }
                }
                
                // Progress with labels
                Group {
                    Text("Progress with Labels")
                        .font(.headline)
                    
                    VStack(spacing: 16) {
                        progressWithLabel(value: 0.25, label: "25%")
                        progressWithLabel(value: 0.5, label: "50%")
                        progressWithLabel(value: 0.75, label: "75%")
                        progressWithLabel(value: 1.0, label: "Complete")
                    }
                }
            }
            .padding()
        }
        .onDisappear {
            // Clean up timers
            downloadTimer?.invalidate()
            uploadTimer?.invalidate()
            taskTimer?.invalidate()
        }
    }
    
    // MARK: - Helper Views
    private func progressSection(title: String, progress: Double, isRunning: Bool, action: @escaping () -> Void, actionTitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            CitrusProgressBar(progress: progress)
            
            Button(action: action) {
                Text(actionTitle)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#27aa00"))
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
        }
    }
    
    private func progressWithLabel(value: Double, label: String) -> some View {
        HStack {
            CitrusProgressBar(progress: value)
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 80)
        }
    }
    
    // MARK: - Actions
    private func toggleDownload() {
        isDownloading.toggle()
        
        if isDownloading {
            downloadTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if downloadProgress < 1.0 {
                    downloadProgress += 0.01
                } else {
                    downloadProgress = 1.0
                    isDownloading = false
                    downloadTimer?.invalidate()
                }
            }
        } else {
            downloadTimer?.invalidate()
        }
    }
    
    private func toggleUpload() {
        isUploading.toggle()
        
        if isUploading {
            uploadTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
                if uploadProgress < 1.0 {
                    uploadProgress += 0.01
                } else {
                    uploadProgress = 1.0
                    isUploading = false
                    uploadTimer?.invalidate()
                }
            }
        } else {
            uploadTimer?.invalidate()
        }
    }
    
    private func toggleTask() {
        isTaskRunning.toggle()
        
        if isTaskRunning {
            taskProgress = 0.0
            taskTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                if taskProgress < 1.0 {
                    taskProgress += 0.005
                } else {
                    taskProgress = 1.0
                    isTaskRunning = false
                    taskTimer?.invalidate()
                }
            }
        } else {
            taskTimer?.invalidate()
        }
    }
}

struct ProgressBarExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarExampleView()
    }
}
