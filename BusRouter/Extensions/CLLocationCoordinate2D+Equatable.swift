//
//  CLLocationCoordinate2D+Equatable.swift
//  BusRouter
//
//  Created by Juan Colilla on 27/12/23.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
