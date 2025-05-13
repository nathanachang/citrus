//
//  RGeocoder.swift
//  Citrus
//
//  Created by Nathan Chang on 5/12/25.
//

import Foundation
import CoreLocation

class RGeocoder {
    private let geocoder = CLGeocoder()
    
    func reverseGeocode(
        latitude: Double,
        longitude: Double,
        completion: @escaping (Result<Address, Error>) -> Void
    ) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(NSError(domain: "No placemark found", code: -1)))
                return
            }
            
            let address = Address(
                name: placemark.name,
                street: placemark.thoroughfare,
                number: placemark.subThoroughfare,
                neighborhood: placemark.subLocality,
                city: placemark.locality,
                state: placemark.administrativeArea,
                postalCode: placemark.postalCode,
                country: placemark.country,
                isoCountryCode: placemark.isoCountryCode
            )
            
            completion(.success(address))
        }
    }
}



struct Address: Equatable {
    let name: String?               // Full place name (e.g., street + number)
    let street: String?            // Street name (thoroughfare)
    let number: String?            // Street number (subThoroughfare)
    let neighborhood: String?      // Sub-locality (neighborhood or district)
    let city: String?              // Locality (city or town)
    let state: String?             // Administrative area (state/province)
    let postalCode: String?        // Zip or postal code
    let country: String?           // Country name
    let isoCountryCode: String?    // 2-letter country code
}
