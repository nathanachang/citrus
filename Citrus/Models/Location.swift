//
//  Location.swift
//  UIMapExample
//
//  Created by Nathan Chang on 2/14/25.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var user_id: Int
    var lat: Double
    var lon: Double
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case user_id
        case lat
        case lon
        case name
    }
    
    // Initialize with UUID for id
    init(user_id: Int, latitude: Double, longitude: Double, name: String) {
        self.id = UUID()
        self.user_id = user_id
        self.lat = latitude
        self.lon = longitude
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the fields you need
        self.user_id = try container.decode(Int.self, forKey: .user_id)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.name = try container.decode(String.self, forKey: .name)

        // Generate a new UUID for 'id'
        self.id = UUID()
        
        // We don't decode 'someField' or any other field not included in the CodingKeys
    }
}
