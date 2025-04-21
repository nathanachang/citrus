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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isPopupPresented = true
                            }
                        }) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                    }
                }
                .overlay(
                    // Only show temporary pin if it exists
                    viewModel.searchPin.map { tempPin in
                        Map(coordinateRegion: .constant(region),
                            annotationItems: [tempPin]) { pin in
                            MapAnnotation(coordinate: pin.coordinate) {
                                // Temporary pin styling
                                VStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                    
                                    Text(pin.title)
                                        .font(.caption)
                                        .padding(4)
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .allowsHitTesting(false) // Let touch events pass through to the base map
                    }
                )
                .edgesIgnoringSafeArea(.all)
            }
            .onAppear {
                viewModel.fetchLocations()
                viewModel.sendMessage(
                    WebSocketAction.sendLocation(
                        latitude: locationManager.userLocation?.coordinate.latitude ?? 40.759211,
                        longitude: locationManager.userLocation?.coordinate.longitude ?? -73.984638
                    ).buildPayload() ?? "Client-side Coordinate Error"
                )
            }
            .onTapGesture {
                isSearchFocused = false
                showSearchResults = false
                viewModel.clearTemporaryPin()
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
        // Use separate condition for sheet to ensure reactivity
        .sheet(
            isPresented: $isPopupPresented,
            onDismiss: {
                print("Sheet dismissed") // Debug print
            },
            content: {
                if let location = selectedLocation {
                    LocationBSView(location: location, isPresented: $isPopupPresented)
                        .presentationDetents([.height(250)])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(Constants.bgNeutral)
                        .presentationCornerRadius(20)
                } else {
                    Text("No location selected")
                        .onAppear {
                            print("Sheet presented without location") // Debug print
                            isPopupPresented = false
                        }
                }
            }
        )
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
        
        // Show the location modal - use same pattern as map annotations
        selectedLocation = newLocation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isPopupPresented = true
        }
        viewModel.setTemporaryPin(for: mapItem)
    }
}
