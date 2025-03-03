//
//  LocationViewModel.swift
//  UIMapExample
//
//  Created by Nathan Chang on 2/14/25.
//

import Combine
import Foundation

class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let apiClient = APIClient()
    
    init() {
        fetchLocations()
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
}
