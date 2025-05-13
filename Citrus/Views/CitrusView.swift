//
//  ContentView.swift
//  UIMapExample
//
//  Created by Nathan Chang on 2/14/25.
//

//
//  RefactorCitrusView.swift
//  Citrus
//
//  Created by Nathan Chang on 5/13/25.
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
    @State private var selectedSpot: Spot? = nil
    @State private var isPopupPresented = false
    @State private var isUserPopupPresented = false
    @State private var showSearchResults = false

    @StateObject private var viewModel = CitrusViewModel()
    @StateObject private var searchService = LocationSearchService()

    var body: some View {
        ZStack {
            VStack {
                mapView
            }
            .onAppear(perform: onAppear)
            .onTapGesture(perform: onMapTap)
            .onChange(of: viewModel.userLocation, perform: onLocationChange)

            searchOverlay
        }
        .sheet(isPresented: $isUserPopupPresented, content: userSheetContent)
        .sheet(isPresented: $isPopupPresented, content: spotSheetContent)
    }

    private var mapView: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: viewModel.mapAnnotations) { item in
            MapAnnotation(coordinate: item.coordinate) {
                switch item {
                case .spot(let spot):
                    SpotAnnotation(spot: spot, onSelect: {
                        selectedSpot = spot
                        isPopupPresented = true
                    })

                case .user(let user):
                    UserAnnotation(user: user, onSelect: {
                        viewModel.switchToUser(user)
                        isUserPopupPresented = true
                    })
                }
            }
        }
        .overlay(tempPinOverlay)
        .edgesIgnoringSafeArea(.all)
    }

    private var tempPinOverlay: some View {
        Group {
            if let pin = viewModel.searchPin {
                Map(coordinateRegion: .constant(region), annotationItems: [pin]) { pin in
                    MapAnnotation(coordinate: pin.coordinate) {
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
                .allowsHitTesting(false)
            }
        }
    }

    private var searchOverlay: some View {
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

    private func onAppear() {
        viewModel.fetchSpots()
        sendLocation(viewModel.userLocation)
    }

    private func onMapTap() {
        isSearchFocused = false
        showSearchResults = false
        viewModel.clearTemporaryPin()
    }

    private func onLocationChange(_ location: CLLocation?) {
        sendLocation(location)
    }

    private func sendLocation(_ location: CLLocation?) {
        guard let loc = location else { return }
        viewModel.sendMessage(
            WebSocketAction.sendLocation(
                latitude: loc.coordinate.latitude,
                longitude: loc.coordinate.longitude
            ).buildPayload() ?? "Client-side Coordinate Error"
        )
    }

    private func handleSearchResultSelection(_ mapItem: MKMapItem) {
        guard let newSpot = searchService.createSpot(from: mapItem) else { return }
        withAnimation {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: newSpot.location.lat, longitude: newSpot.location.lon),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
        showSearchResults = false
        isSearchFocused = false
        searchQuery = ""
        selectedSpot = newSpot
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isPopupPresented = true
        }
        viewModel.setTemporaryPin(for: mapItem)
    }

    private func userSheetContent() -> some View {
        if let user = viewModel.selectedUser {
            return AnyView(
                UserBSView(userViewModel: user, isPresented: $isUserPopupPresented)
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Constants.bgNeutral)
                    .presentationCornerRadius(20)
            )
        } else {
            return AnyView(
                Text("No user selected").onAppear { isUserPopupPresented = false }
            )
        }
    }

    private func spotSheetContent() -> some View {
        if let spot = selectedSpot {
            return AnyView(
                LocationBSView(spot: spot, isPresented: $isPopupPresented)
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Constants.bgNeutral)
                    .presentationCornerRadius(20)
            )
        } else {
            return AnyView(
                Text("No location selected").onAppear { isPopupPresented = false }
            )
        }
    }
}

// Subviews
struct SpotAnnotation: View {
    let spot: Spot
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.red)
                .font(.title)
        }
    }
}

struct UserAnnotation: View {
    let user: User
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 4) {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title)
                Text(user.pref_name)
                    .font(.caption2)
                    .foregroundColor(.black)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(4)
            }
        }
    }
}
