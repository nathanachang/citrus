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
    @State private var showSearchResults = false
    
    @StateObject private var viewModel = LocationViewModel()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchService = LocationSearchService()
    
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
                showSearchResults = false
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
                VStack(spacing: 0) {
                    SearchBarView(
                        searchQuery: $searchQuery,
                        isSearchFocused: $isSearchFocused,
                        onSearchQueryChanged: { query in
                            searchService.search(query: query, region: region)
                            showSearchResults = !query.isEmpty
                        },
                        showClearButton: !searchQuery.isEmpty,
                        onClearTapped: {
                            searchQuery = ""
                            showSearchResults = false
                        }
                    )
                    
                    // Search results dropdown
                    if showSearchResults && !searchService.searchResults.isEmpty {
                        SearchResultsView(
                            searchResults: searchService.searchResults,
                            onResultSelected: handleSearchResultSelection
                        )
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // Handle selection of a search result
    private func handleSearchResultSelection(_ mapItem: MKMapItem) {
        guard let newLocation = searchService.createLocation(from: mapItem) else { return }
        
        // Update the map region
        withAnimation {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: newLocation.lat, longitude: newLocation.lon),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
        
        // Hide search results and update search query
        showSearchResults = false
        isSearchFocused = false
        searchQuery = ""
        
        // Show the location modal
        selectedLocation = newLocation
        isPopupPresented = true
    }
}

