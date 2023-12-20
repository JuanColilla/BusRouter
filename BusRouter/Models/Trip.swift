//
//  Trip.swift
//  BusRouter
//
//  Created by Juan Colilla on 20/12/23.
//

import Foundation
import CoreLocation

struct Trip: Codable, Equatable {
    var driverName: String
    var status: String
    var route: String
    var startTime: String
    var endTime: String
    var description: String
    var origin: Location
    var destination: Location
    var stops: [Stop]

    struct Location: Codable, Equatable {
        var address: String
        var point: Coordinate

        struct Coordinate: Codable, Equatable {
            var _latitude: CLLocationDegrees
            var _longitude: CLLocationDegrees
        }
    }

    struct Stop: Codable, Equatable {
        var id: Int?
        var point: Location.Coordinate?
    }
}
