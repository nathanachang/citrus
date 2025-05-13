//
//  MapItem.swift
//  Citrus
//
//  Created by Nathan Chang on 5/13/25.
//

import Foundation
import CoreLocation

enum MapItem: Identifiable {
    case spot(Spot)
    case user(User)
    
    var id: UUID {
        switch self {
        case .spot(let spot): return spot.id
        case .user(let user): return user.id
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .spot(let spot):
            return CLLocationCoordinate2D(latitude: spot.location.lat, longitude: spot.location.lon)
        case .user(let user):
            return CLLocationCoordinate2D(latitude: user.location.lat, longitude: user.location.lon)
        }
    }
}
