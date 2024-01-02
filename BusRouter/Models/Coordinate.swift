//
//  Coordinate.swift
//  BusRouter
//
//  Created by Juan Colilla on 2/1/24.
//

import CoreLocation
import Foundation

struct Coordinate: Codable, Equatable, Hashable {
  var latitude: CLLocationDegrees
  var longitude: CLLocationDegrees

  enum CodingKeys: String, CodingKey {
    case latitude = "_latitude"
    case longitude = "_longitude"
  }
}

extension Coordinate {
  var cllocationCoordinate2D: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
  }
}
