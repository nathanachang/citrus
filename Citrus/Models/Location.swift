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
    var lat: Double
    var lon: Double
    var timestamp: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case timestamp
    }
    
    // Initialize with UUID for id
    init(latitude: Double, longitude: Double, timestamp: TimeInterval) {
        self.id = UUID()
        self.lat = latitude
        self.lon = longitude
        self.timestamp = timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)

        self.id = UUID()
    }
}
