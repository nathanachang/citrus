//
//  LocationViewModel.swift
//  UIMapExample
//
//  Created by Nathan Chang on 2/14/25.
//

import Combine
import Foundation
import MapKit

class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var searchPin: TemporaryAnnotation? = nil
    @Published var userLocation: CLLocation?
        
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    private let apiClient = APIClient()
    private let webSocketManager = WebSocketManager()
    
    init() {
        fetchLocations()
        webSocketManager.connect()
        locationManager.$userLocation
            .assign(to: &$userLocation)
    }
    
    func fetchLocations() {
        apiClient.fetchLocations()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching locations.")
                case .failure(let error):
                    print("Error fetching locations: \(error)")
                }
            }, receiveValue: { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                }
            })
            .store(in: &cancellables)
    }
    
    func setTemporaryPin(for mapItem: MKMapItem) {
        let coordinate = mapItem.placemark.coordinate
        searchPin = TemporaryAnnotation(
            id: UUID().uuidString,
            coordinate: coordinate,
            title: mapItem.name ?? "Location"
        )
    }
    
    func clearTemporaryPin() {
        searchPin = nil
    }
    
    func sendMessage(_ text: String) {
        webSocketManager.sendMessage(text)
    }
}
