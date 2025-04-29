//
//  User.swift
//  Citrus
//
//  Created by Nathan Chang on 4/29/25.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    var id: UUID
    var user_id: Int
    var username: String
    var pref_name: String
    var location: Location
    var group_ids: [Int]
    
    enum CodingKeys: String, CodingKey {
        case user_id
        case username
        case pref_name
        case location
        case group_ids
    }
    
    init(user_id: Int, username: String, pref_name: String, location: Location, group_ids: [Int]) {
        self.id = UUID()
        self.user_id = user_id
        self.username = username
        self.pref_name = pref_name
        self.location = location
        self.group_ids = group_ids
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.user_id = try container.decode(Int.self, forKey: .user_id)
        self.username = try container.decode(String.self, forKey: .username)
        self.pref_name = try container.decode(String.self, forKey: .pref_name)
        self.location = try container.decode(Location.self, forKey: .location)
        self.group_ids = try container.decode([Int].self, forKey: .group_ids)
        
        self.id = UUID()
    }
}
