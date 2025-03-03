//
//  APIClient.swift
//  UIMapExample
//
//  Created by Nathan Chang on 2/14/25.
//

import Combine
import Foundation

class APIClient {
    func fetchLocations() -> AnyPublisher<[Location], Error> {
        // Replace with your actual API endpoint
        let url = URL(string: "https://391c9f2a-fc5e-482c-9581-90fd26294aea.mock.pstmn.io/location")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Location].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

