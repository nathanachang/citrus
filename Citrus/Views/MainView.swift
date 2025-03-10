//
//  MainView.swift
//  Citrus
//
//  Created by Paul Minyoo Kim on 3/9/25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    // Define the purple color to match Figma
    private let accentColor = Color(hex: "#9747ff")
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Display content based on the selected tab
            Group {
                if selectedTab == 0 {
                    CitrusView()
                } else if selectedTab == 1 {
                    SegmentedControlExampleView()
                } else if selectedTab == 2 {
                    ProgressBarExampleView()
                } else if selectedTab == 3 {
                    WebSocketScreen()
                } else if selectedTab == 4 {
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab, accentColor: accentColor)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let accentColor: Color
    
    // Tab item data
    private let tabs = [
        (title: "Map", icon: "map"),
        (title: "Plan", icon: "list.bullet"),
        (title: "Saved", icon: "bookmark"),
        (title: "Inbox", icon: "envelope.badge"),
        (title: "Profile", icon: "person.circle")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].icon)
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == index ? accentColor : Color.gray)
                        
                        Text(tabs[index].title)
                            .font(.caption)
                            .foregroundColor(selectedTab == index ? accentColor : Color.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .background(Color(UIColor.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .top
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
    }
}

// Helper extension to create Color from hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Keep the existing view implementations
struct MapView: View {
    var body: some View {
        NavigationView {
            Text("Map View")
                .navigationBarTitle("Map", displayMode: .inline)
        }
    }
}

struct PlanView: View {
    var body: some View {
        NavigationView {
            Text("Plan Screen")
                .navigationBarTitle("Plan", displayMode: .inline)
        }
    }
}

struct SavedView: View {
    var body: some View {
        NavigationView {
            Text("Saved Screen")
                .navigationBarTitle("Saved", displayMode: .inline)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            Text("Profile Screen")
                .navigationBarTitle("Profile", displayMode: .inline)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
