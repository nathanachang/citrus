//
//  LocationViewModel.swift
//  UIMapExample
//
//  Created by Nathan Chang on 2/14/25.
//

import Combine
import Foundation
import MapKit

class CitrusViewModel: ObservableObject {
    @Published var spots: [Spot] = []
    @Published var users: [User] = []
    @Published var selectedUser: UserViewModel? = nil
    @Published var searchPin: TemporaryAnnotation? = nil
    @Published var userLocation: CLLocation?
    
    var mapAnnotations: [MapItem] {
        spots.map { .spot($0) } + users.map { .user($0) }
    }
        
    private var locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    private let apiClient = APIClient()
    private let webSocketManager = WebSocketManager()
    
    init() {
        fetchSpots()
        fetchUsers()
        webSocketManager.connect()
        locationManager.$userLocation
            .assign(to: &$userLocation)
    }
    
    func fetchSpots() {
        apiClient.fetchSpots()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching locations.")
                case .failure(let error):
                    print("Error fetching locations: \(error)")
                }
            }, receiveValue: { [weak self] spots in
                DispatchQueue.main.async {
                    self?.spots = spots
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchUsers() {
        apiClient.fetchUsers()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching users.")
                case .failure(let error):
                    print("Error fetching users: \(error)")
                }
            }, receiveValue: { [weak self] users in
                DispatchQueue.main.async {
                    self?.users = users
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
    
    func switchToUser(_ user: User) {
        selectedUser = UserViewModel(user: user)
        print("Switching to user \(user.pref_name)")
    }
    
    func sendMessage(_ text: String) {
        webSocketManager.sendMessage(text)
    }
}
