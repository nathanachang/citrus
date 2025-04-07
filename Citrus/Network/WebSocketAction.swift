//
//  WebSocketAction.swift
//  Citrus
//
//  Created by Nathan Chang on 4/7/25.
//

import Foundation

enum WebSocketAction {
    case sendLocation(latitude: Double, longitude: Double)
    
    func buildPayload() -> String? {
        var payload: [String: Any] = [:]
        
        switch self {
        case .sendLocation(let lat, let long):
            payload["action"] = "sendLocation"
            payload["latitude"] = lat
            payload["longitude"] = long
            payload["timestamp"] = Date().timeIntervalSince1970
            
            if let data = try? JSONSerialization.data(withJSONObject: payload),
               let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            }
            
            return nil
        }
    }
}
