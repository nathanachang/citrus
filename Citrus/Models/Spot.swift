//
//  Spot.swift
//  Citrus
//
//  Created by Nathan Chang on 4/29/25.
//

import Foundation

struct Spot: Identifiable, Codable, Equatable {
    var id: UUID
    var spot_id: Int
    var name: String
    var location: Location
    
    enum CodingKeys: String, CodingKey {
        case spot_id
        case name
        case location
    }
    
    init(spot_id: Int, name: String, location: Location) {
        self.id = UUID()
        self.spot_id = spot_id
        self.name = name
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.spot_id = try container.decode(Int.self, forKey: .spot_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.location = try container.decode(Location.self, forKey: .location)
        
        self.id = UUID()
    }
}
