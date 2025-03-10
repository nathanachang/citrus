//
//  ContentView.swift
//  UIMapExample
//
//  Created by Nathan Chang on 2/14/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct CitrusView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.760082, longitude: -73.983249),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var searchQuery: String = ""
    @FocusState private var isSearchFocused: Bool
    @State private var selectedLocation: Location? = nil
    @State private var isPopupPresented = false
    
    @StateObject private var viewModel = LocationViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            VStack {
                Map(
                    coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: viewModel.locations
                ) { location in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)) {
                        Button(action: {
                            selectedLocation = location
                            isPopupPresented = true
                        }) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                    }
                    /*
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)) {
                        VStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title)
                                .background(Circle().fill(Color.white))
                        }
                    }
                     */
                }
                .edgesIgnoringSafeArea(.all)
            }
            .onAppear {
                viewModel.fetchLocations()
            }
            .onTapGesture {
                isSearchFocused = false
            }
            
            // Conditionally show the Popup if `isPopupPresented` is true
            if isPopupPresented, let location = selectedLocation {
                GeometryReader { geometry in
                    Color.black.opacity(0.5) // Semi-transparent background to dim the rest of the view
                        .onTapGesture {
                            withAnimation {
                                isPopupPresented = false // Dismiss pop-up when tapping outside
                            }
                        }
                        .edgesIgnoringSafeArea(.all) // Ensure it covers the entire screen
                    LocationModalView(location: location, isPresented: $isPopupPresented)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // This centers the view
                        .zIndex(1)
                }
                .edgesIgnoringSafeArea(.all) // Ensures background is visible outside the popup
            }
            
            VStack {
                ZStack(alignment: .leading) {
                    // Background and styling of the TextField
                    TextField("Enter text here", text: $searchQuery) // Replace with your actual binding variable
                        .padding(.vertical, Constants.spacingTight)
                        .padding(.leading, Constants.spacingDefault + 18) // Add extra padding for the left icon space
                        .padding(.horizontal, Constants.spacingDefault)
                        .background(Constants.bgActionNeutralDefault)
                        .cornerRadius(999)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        .textFieldStyle(PlainTextFieldStyle()) // Removes default padding
                        .overlay(
                            RoundedRectangle(cornerRadius: 999)
                            .inset(by: 1)
                            .stroke(isSearchFocused ? Constants.borderMuted : Color.clear, lineWidth: Constants.border50)
                            .animation(.easeInOut(duration: 0.25), value: isSearchFocused)
                        )
                        .focused($isSearchFocused)
                        .onTapGesture {
                            isSearchFocused = true
                        }
                    // Left Icon
                    Image(.citrusLogo)
                        .padding(.leading, Constants.spacingDefault)
                    
                    // Right Icon
                    HStack {
                        Spacer()
                        Image(.microphone)
                            .padding(.trailing, Constants.spacingDefault)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: Constants.searchWidth)
                
                Spacer()
            }
            
        }
    }
}

struct CitrusView_Previews: PreviewProvider {
    static var previews: some View {
        CitrusView()
    }
}


