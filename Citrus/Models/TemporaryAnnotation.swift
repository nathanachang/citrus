//
//  TemporaryAnnotation.swift
//  Citrus
//
//  Created by Nathan Chang on 3/31/25.
//

import CoreLocation

struct TemporaryAnnotation: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String
}
