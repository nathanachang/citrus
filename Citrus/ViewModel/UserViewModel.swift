//
//  UserViewModel.swift
//  Citrus
//
//  Created by Nathan Chang on 5/12/25.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User
    @Published var address: String
    
    private let geocoder = RGeocoder()
    
    init(user: User) {
        self.user = user
        self.address = "Address Unknown"
        updateAddress()
    }
    
    func setUser(_ newUser: User) {
        self.user = newUser
        updateAddress()
    }
    
    private func updateAddress() {
        geocoder.reverseGeocode(
            latitude: user.location.lat,
            longitude: user.location.lon
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let address):
                    self?.address = address.name!
                case .failure:
                    self?.address = "Address Unknown"
                }
            }
        }
    }
}

