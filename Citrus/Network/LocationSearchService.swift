//
//  LocationSearchService.swift
//  Citrus
//
//  Created by Nathan Chang on 3/20/25.
//

import Foundation
import MapKit
import Combine

class LocationSearchService: NSObject, ObservableObject {
    @Published var searchResults: [MKMapItem] = []
    @Published var isSearching = false
    
    private var searchCancellable: AnyCancellable?
    private let searchSubject = PassthroughSubject<(String, MKCoordinateRegion), Never>()
    private var completer: MKLocalSearchCompleter?
    
    override init() {
        super.init()
        
        // Set up the completer for predictive search
        completer = MKLocalSearchCompleter()
        completer?.delegate = self
        completer?.resultTypes = .pointOfInterest
        
        // Set up the debounced search pipeline
        searchCancellable = searchSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query, region in
                self?.performSearch(query: query, region: region)
            }
    }
    
    func search(query: String, region: MKCoordinateRegion) {
        // Begin searching even with 1-2 characters
        guard query.count >= 1 else {
            self.searchResults = []
            return
        }
        
        // Set the region for the completer
        completer?.region = region
        
        // Update the search fragment
        completer?.queryFragment = query
        
        // Also queue the standard search through the debounced pipeline
        searchSubject.send((query, region))
    }
    
    private func performSearch(query: String, region: MKCoordinateRegion) {
        isSearching = true
        
        let request = MKLocalSearch.Request()
        
        // Format the query to prioritize business categories
        // By prefixing with "nearby" we bias toward local businesses
        request.naturalLanguageQuery = "nearby \(query)"
        request.region = region
        
        // Explicitly set to prioritize points of interest
        request.resultTypes = .pointOfInterest
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            
            self.isSearching = false
            
            guard error == nil else {
                print("Error searching: \(error!.localizedDescription)")
                return
            }
            
            guard let response = response, !response.mapItems.isEmpty else {
                // If no POIs found, try a more general search
                self.performGeneralSearch(query: query, region: region)
                return
            }
            
            // Sort results to prioritize those that start with the query
            let sortedItems = self.sortResultsByRelevance(items: response.mapItems, query: query)
            self.searchResults = sortedItems
        }
    }
    
    // Fallback to a more general search if no POIs are found
    private func performGeneralSearch(query: String, region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        
        // Include all result types for the general search
        request.resultTypes = [.pointOfInterest, .address]
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            
            guard error == nil,
                  let response = response else {
                self.searchResults = []
                return
            }
            
            let sortedItems = self.sortResultsByRelevance(items: response.mapItems, query: query)
            self.searchResults = sortedItems
        }
    }
    
    // Sort results to prioritize items that start with the query text
    private func sortResultsByRelevance(items: [MKMapItem], query: String) -> [MKMapItem] {
        let lowercaseQuery = query.lowercased()
        
        return items.sorted { item1, item2 in
            let name1 = item1.name?.lowercased() ?? ""
            let name2 = item2.name?.lowercased() ?? ""
            
            // First priority: names that start with the query
            let name1StartsWithQuery = name1.hasPrefix(lowercaseQuery)
            let name2StartsWithQuery = name2.hasPrefix(lowercaseQuery)
            
            if name1StartsWithQuery && !name2StartsWithQuery {
                return true
            } else if !name1StartsWithQuery && name2StartsWithQuery {
                return false
            }
            
            // Second priority: names that contain the query
            let name1ContainsQuery = name1.contains(lowercaseQuery)
            let name2ContainsQuery = name2.contains(lowercaseQuery)
            
            if name1ContainsQuery && !name2ContainsQuery {
                return true
            } else if !name1ContainsQuery && name2ContainsQuery {
                return false
            }
            
            // Third priority: distance from center of region
            return name1 < name2 // Default alphabetical ordering
        }
    }
    
    // Creates a Location model from an MKMapItem
    func createLocation(from mapItem: MKMapItem, userId: Int = 0) -> Location? {
        guard let name = mapItem.name, let location = mapItem.placemark.location else { return nil }
        
        return Location(
            user_id: userId,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            name: name
        )
    }
    
    // Helper function to extract address from map item
    static func getAddressFromItem(_ mapItem: MKMapItem) -> String? {
        guard let placemark = mapItem.placemark as? MKPlacemark else { return nil }
        
        let addressComponents = [
            placemark.thoroughfare,
            placemark.locality,
            placemark.administrativeArea
        ].compactMap { $0 }
        
        return addressComponents.joined(separator: ", ")
    }
}

// MARK: - MKLocalSearchCompleter Delegate
extension LocationSearchService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard !completer.results.isEmpty else { return }
        
        // Convert completer results to map items via search
        let firstFive = Array(completer.results.prefix(5))
        
        // Process each completion result
        for completion in firstFive {
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            
            search.start { [weak self] response, error in
                guard let self = self,
                      error == nil,
                      let mapItems = response?.mapItems,
                      !mapItems.isEmpty else { return }
                
                // Only update if we still have relevant results
                if self.isSearching {
                    // Merge with existing results, avoiding duplicates
                    let existingNames = Set(self.searchResults.compactMap { $0.name })
                    let newItems = mapItems.filter { !existingNames.contains($0.name ?? "") }
                    
                    if !newItems.isEmpty {
                        self.searchResults = (self.searchResults + newItems)
                            .sorted { ($0.name ?? "") < ($1.name ?? "") }
                    }
                }
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
}
